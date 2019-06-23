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
        var content:String = ""
        var star:Int = 0
    }
    
    var items = [Evaluation]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel!.text = self.items[indexPath.row].content
        cell.detailTextLabel!.text = String(self.items[indexPath.row].star)//星の個数を入れる
        return cell
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
                for row in evaluations {
                    print("content:\(String(row.content)) star:\(String(row.star))")
                }
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
            items += [evaluation]
        }
    }
}
