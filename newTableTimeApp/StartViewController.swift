//
//  StartViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/08.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var player = AVPlayer()
    @IBOutlet var textField: UITextField!
    let alert: UIAlertController = UIAlertController(title: "所属が選択されていません", message: "所属を選択してください！", preferredStyle:  UIAlertController.Style.alert)
    
    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
        (action: UIAlertAction!) -> Void in
        print("OK")
    })
    
    var pickerView: UIPickerView = UIPickerView()
    let list = ["所属を選択してね", "農学部", "理工学部", "教育学部", "人文社会学部", "総合科学研究科", "教育学研究科", "理工学研究科", "獣医学研究科", "連合農学研究科", "その他"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(defaultAction)

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        toolbar.setItems([doneItem], animated: true)
        
        self.textField.inputView = pickerView
        self.textField.inputAccessoryView = toolbar
        
        
        let path = Bundle.main.path(forResource: "start", ofType: "mov")
        
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player.play()
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.repeatCount = 0
        playerLayer.zPosition = -1
        view.layer.insertSublayer(playerLayer, at: 0)
        
        
        //無限ループ 終わったらまた0を探して発生
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main){ (notification)
            in
            self.player.seek(to: .zero)
            self.player.play()
        }
        
    }
    
    @objc func done(){
        self.textField.endEditing(true)
    }
    
    override func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?) -> Bool {
        
        if identifier == "startSegue" {
            if (textField.text != "所属を選択してね"){
                player.pause()
                UserDefaults.standard.set(textField.text, forKey: "userInformation")
                return true
            }
        }
        //alert表示
        present(alert, animated: true, completion: nil)
        return false
    }
    
}
