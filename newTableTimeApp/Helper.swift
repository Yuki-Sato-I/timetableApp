//
//  Helper.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/22.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

protocol AlertHelper{
    func makeAndShowAlert(title: String, message: String, viewController: UIViewController, action:[UIAlertAction])
}
extension AlertHelper{
    func makeAndShowAlert(title: String, message: String, viewController: UIViewController, action: [UIAlertAction]){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        if(action.isEmpty){
            alert.addAction(defaultAction)
        }else{
            for alertAction in action {
                alert.addAction(alertAction)
            }
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
