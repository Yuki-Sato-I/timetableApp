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
    var classNames: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        classNames = UserDefaults.standard.object(forKey: "classNames") as! [String]
        self.title = "todo"
        //登録されているtodoを読み込み
        if (UserDefaults.standard.object(forKey: "todoListItem") != nil){
            let data = UserDefaults.standard.object(forKey: "todoListItem")
            itemArray = try! JSONDecoder().decode([Item].self, from: data as! Data)
        }
        
        for _ in 0..<3{
            itemArray.append(Item(className: "as", done: false, title: "aaa", content: "a", limitDate: "2019/4"))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return classNames.count
    }
    
    // Sectioのタイトル
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return classNames[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0
        for i in 0..<itemArray.count {
            if itemArray[i].className == classNames[section] {
                count += 1
            }
        }
        return count
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
    
    //戻ってきたときの画面リロード
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidLoad()
        tableView.reloadData()
    }

}
