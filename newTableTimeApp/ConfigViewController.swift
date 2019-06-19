//
//  ConfigViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/16.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let alert: UIAlertController = UIAlertController(title: "未記入の項目があります", message: "全て入力してください", preferredStyle:  UIAlertController.Style.alert)
    
    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
        (action: UIAlertAction!) -> Void in
        print("OK")
    })
    /* 授業を選択しpickerを開いてから　textFieldを開いたときに、pickerは閉じていたい */
    
    @IBOutlet var label: UILabel!
    @IBOutlet var vi: UIView!
    
    @IBOutlet var textFieldView: UIView! //textFieldをまとめてある
    @IBOutlet var classTextField: UITextField!
    @IBOutlet var teacherTextField: UITextField!
    @IBOutlet var creditTextField: UITextField!
    
    @IBOutlet var registerButton: UIButton!//登録ボタン
    
    var toolbar: UIToolbar!
    var picker: UIPickerView = UIPickerView()
    
    var day = ""
    var selectedNumber = 500//番号はあり得ないやつにしている
    
    //選んだ授業情報が入っている
    var classInfo = CellViewController.ClassInfo()
    
    //重複タップ用
    var isTapped  = false
    
    let screenSize = UIScreen.main.bounds.size
    //デバック用リスト
    let list = ["授業を選択してください", "1", "2", "3", "4", "5", "6", "7", "8", "9", "自分で登録する"]
    let credit = ["0", "1", "2", "3", "4"]
    
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
        self.label.text = list[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //どっかタッチしたら発火
        classTextField.resignFirstResponder()
        teacherTextField.resignFirstResponder()
        creditTextField.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "授業設定"
        alert.addAction(defaultAction)
        
        label.textAlignment = .center
        label.center.x = self.view.center.x
        
        textFieldView.center.x = self.view.center.x
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        creditTextField.keyboardType = UIKeyboardType.numberPad
        
        textFieldsAreEnabled(bool: false)

    }
    
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        print("*")
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        /*重複タップ禁止*/
        if(!isTapped){
        
            picker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: picker.bounds.size.height)
            picker.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)//薄いグレー
        
            vi.frame = picker.bounds
            vi.backgroundColor = .white
            vi.addSubview(picker)
        
            toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ConfigViewController.done))
            toolbar.setItems([doneItem], animated: true)
            toolbar.isUserInteractionEnabled = true
            toolbar.sizeToFit()
        
            vi.addSubview(toolbar)
            view.addSubview(vi)
        
            vi.frame.origin.y = screenSize.height
            UIView.animate(withDuration: 0.3) {
                self.vi.frame.origin.y = self.screenSize.height - self.vi.bounds.size.height
            }
            isTapped = true
        }
    }
    
    @objc func done() {
        self.label.endEditing(true)
        
        if(isTapped){
            UIView.animate(withDuration: 0.3) {
                self.vi.frame.origin.y += self.vi.bounds.size.height
            }
            isTapped = false
        }
        if(label.text == "自分で登録する"){
            textFieldsAreEnabled(bool: true)
        }else{
            textFieldsAreEnabled(bool: false)
            //textFieldたちにも自動で代入させたい
        }
    }
    
    //trueならtextFieldの有効化,
    func textFieldsAreEnabled(bool: Bool){
        if(bool){
            classTextField.isUserInteractionEnabled = true
            teacherTextField.isUserInteractionEnabled = true
            creditTextField.isUserInteractionEnabled = true
            classTextField.backgroundColor = .white
            teacherTextField.backgroundColor = .white
            creditTextField.backgroundColor = .white
        }else{
            classTextField.isUserInteractionEnabled = false
            teacherTextField.isUserInteractionEnabled = false
            creditTextField.isUserInteractionEnabled = false
            classTextField.text = ""
            teacherTextField.text = ""
            creditTextField.text = ""
            classTextField.backgroundColor = .lightGray
            teacherTextField.backgroundColor = .lightGray
            creditTextField.backgroundColor = .lightGray
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if(classTextField.text != "" && teacherTextField.text != "" && creditTextField.text != ""){
            
            classInfo.title = classTextField.text!
            classInfo.teacher = teacherTextField.text!
            classInfo.credit = Int(creditTextField.text!)!
            classInfo.faculty = UserDefaults.standard.object(forKey: "userInfomation") as! String
            classInfo.day = day
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(classInfo) {
                UserDefaults.standard.set(encoded, forKey: String(selectedNumber))
            }
            print(classInfo)
            self.navigationController?.popViewController(animated: true)
        }else{
            present(alert, animated: true, completion: nil)
        }
    }
}
