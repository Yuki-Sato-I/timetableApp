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
        //デバックアイテム
        for i in 0..<3{
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
        
    }
    
    // ios 11以上が必要
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let buttonTitle = itemArray[indexPath.row].done ? "not yet" : "done"
        
        let doneAction = UIContextualAction(style: .normal, title: buttonTitle) { (action, view, completionHandler) in completionHandler(true)
            print("done")
            var item = self.itemArray[indexPath.row]
            // チェックマーク
            item.done = !item.done
            
            self.itemArray[indexPath.row] = item
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.itemArray) {
                UserDefaults.standard.set(encoded, forKey: "todoListItem")
            }
            self.tableView.reloadData()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, completionHandler) in completionHandler(true)
            print("delete")
            self.itemArray.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.itemArray) {
                UserDefaults.standard.set(encoded, forKey: "todoListItem")
            }

            self.tableView.reloadData()
        }
        
        doneAction.backgroundColor = .blue

        let configuration = UISwipeActionsConfiguration(actions: [doneAction, deleteAction])
        return configuration
    }
    
}
