//
//  CommentMakeViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/24.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit
import Cosmos

class CommentMakeViewController: UIViewController {

    var classId:Int!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var entireView: UIView!
    @IBOutlet var star: CosmosView!
    
    @IBOutlet var evaluationLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var buttonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entireView.center.x = self.view.center.x
        star.settings.fillMode = .half
        star.rating = 3.0
        self.title = "この授業を評価する"
    }

    
    func postJson(urlString: String, parameters: [String: Any]){
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let parametersString: String = parameters.enumerated().reduce("") { (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let double as Double: return input + tuple.element.key + "=" + String(double) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let boolean as Bool: return input + tuple.element.key + "=" + String(boolean) + (parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        
        request.httpBody = parametersString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }

    
    @IBAction func sendButton(_ sender: Any) {
        let params:[String: Any] = [
            "timetable_id": classId!,
            "title": titleTextField.text!,
            "content": commentTextField.text!,
            "user": nameTextField.text!,
            "star": star.rating,
            "permission": false
        ]
        print(star.rating)
        postJson(urlString: "http://localhost:3000/apis/create_evaluation", parameters: params)
    }
    
}
