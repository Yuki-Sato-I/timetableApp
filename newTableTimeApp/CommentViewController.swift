//
//  CommentViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/22.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //選ばれた授業のidが入る
    var classId:Int = -999

    @IBOutlet var tableView: UITableView!
    
    //評価が入る
    struct Evaluation: Codable{
        var id:Int = 0
        var title:String = ""
        var content:String = ""
        var user:String = ""
        var star:Double = 0.0
        var permission:Bool = false
    }
    
    var items = [Evaluation]()
    var selectedItem:Evaluation!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel!.text = self.items[indexPath.row].title
        //cell.detailTextLabel!.text = String(self.items[indexPath.row].star)//星の個数を入れる
        return cell
    }
    
    // cellが押されたときに呼ばれる関数
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "TableViewCellSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TableViewCellSegue") {
            let vc = segue.destination as! CommentCellViewController
            vc.evaluation = selectedItem
        }else if(segue.identifier == "makeEvaluationPageSegue"){
            let vc = segue.destination as! CommentMakeViewController
            vc.classId = classId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getJson()

    }
    
    //apiを叩いて該当する評価を取得し、表示する
    func getJson(){
        //デバック用
        let urlString = "http://localhost:3000/apis/voice_index/\(classId)"

        //本番用
        //let urlString = ""

        guard let url = URLComponents(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            
            guard let _data = data else { return }
            // JSONデコード
            do {
                let evaluations = try JSONDecoder().decode([Evaluation].self, from: _data)
                self.evaluationsIntoItems(evaluationArray: evaluations)
                print("-------------")
                print(self.items)
                print("-------------")
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func evaluationsIntoItems(evaluationArray:[Evaluation]){
        for evaluation in evaluationArray{
            if(evaluation.permission){
                items += [evaluation]
            }
        }
    }
}
