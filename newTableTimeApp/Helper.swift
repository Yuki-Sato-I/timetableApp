//
//  Helper.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/22.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

protocol AlertHelper{
    func makeAndShowAlert(errorTitle: String, errorMessage: String, viewController: UIViewController)
}
extension AlertHelper{
    func makeAndShowAlert(errorTitle: String, errorMessage: String, viewController: UIViewController){
        let alert: UIAlertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
