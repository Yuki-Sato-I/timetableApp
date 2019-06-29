//
//  TodoListTableViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/28.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    struct Item: Codable {
        var className:String!
        var done: Bool = false
        var title:String!
        var content:String!
        var limitDate:String!
    }
    
    var itemArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "todo"
        //登録されているtodoを読み込み
        if (UserDefaults.standard.object(forKey: "todoListItem") != nil){
            let data = UserDefaults.standard.object(forKey: "todoListItem")
            itemArray = try! JSONDecoder().decode([Item].self, from: data as! Data)
        }
        print(itemArray)
        //デバックアイテム
        for i in 0..<10{
            let item1 = Item(className: String(i), done: false, title: String(i), content: "wwwww", limitDate: "2017/08/13")
            itemArray.append(item1)
        }
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = itemArray[indexPath.row]
        // チェックマーク
        item.done = !item.done
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(itemArray) {
            UserDefaults.standard.set(encoded, forKey: "todoListItem")
        }
        // リロードしてUIに反映
        self.tableView.reloadData()
        // セルを選択した時の背景の変化を遅くする
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            itemArray.remove(at: indexPath.row)

            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(itemArray) {
                UserDefaults.standard.set(encoded, forKey: "todoListItem")
            }
            tableView.reloadData()
        }
    }

}
