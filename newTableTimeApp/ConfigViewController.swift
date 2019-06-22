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
    
    @IBOutlet var label: UILabel!
    @IBOutlet var vi: UIView!
    
    @IBOutlet var textFieldView: UIView! //textFieldをまとめてある
    @IBOutlet var classTextField: UITextField!
    @IBOutlet var teacherTextField: UITextField!
    @IBOutlet var creditTextField: UITextField!
    
    @IBOutlet var registerButton: UIButton!//登録ボタン
    
    var toolbar: UIToolbar!
    var picker: UIPickerView = UIPickerView()
    
    /* 曜日 */
    var day = ""
    /* 6で割って1を足すと何コマ目かがわかる */
    var selectedNumber = 500//番号はあり得ないやつにしている
    /* 自分の学部 */
    let faculty = UserDefaults.standard.object(forKey: "userInformation") ?? "その他"

    struct Information: Codable{
        var id: Int = -100
        var title:String = "授業を選択してください"
        var teacher:String = "登録されていません"
        var credit:Int = 0
        var day:String = "Monday"
        var faculty:String = "理工学部"
    }
    //重複タップ用
    var isTapped  = false
    //スクリーンの大きさ
    let screenSize = UIScreen.main.bounds.size
    //授業リスト
    var list:[Information] = [Information(), Information(id: 9999999999, title: "自分で登録する", teacher: "登録されていません", credit: 0, day: "Monday", faculty: "理工学部")]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        list.sort{ $0.id < $1.id }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.label.text = list[row].title
        if(label.text == "自分で登録する"){
            textFieldsAreEnabled(bool: true)
            classTextField.text = ""
            teacherTextField.text = ""
            creditTextField.text = ""
        }else{
            textFieldsAreEnabled(bool: false)
            if(label.text != "授業を選択してください"){
                classTextField.text = list[row].title
                teacherTextField.text = list[row].teacher
                creditTextField.text = String(list[row].credit)
            }
        }
    }
    
    //returnが押された時キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //pickerを開いてから,textFieldを開いたときに,pickerは閉じる
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTapped = false
        closePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //どっかタッチしたら発火
        classTextField.resignFirstResponder()
        teacherTextField.resignFirstResponder()
        creditTextField.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        getJson()
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
        
        /* pickerの作成 */
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
        vi.frame.origin.y = screenSize.height
        view.addSubview(vi)
        
        
    }
    
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        print("*")
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        /*重複タップ禁止*/
        if(!isTapped){
            openPicker()
            isTapped = true
        }
    }
    
    @objc func done() {
        self.label.endEditing(true)
        
        if(isTapped){
            closePicker()
            isTapped = false
        }
    }
    
    //授業を登録する
    @IBAction func register(_ sender: Any) {
        if(classTextField.text != "" && teacherTextField.text != "" && creditTextField.text != ""){
            let classInfo = CellViewController.ClassInfo(title: classTextField.text!,
                                                         teacher: teacherTextField.text!,
                                                         credit: Int(creditTextField.text!)!,
                                                         day: day,
                                                         faculty: UserDefaults.standard.object(forKey: "userInformation") as! String,
                                                         specialty: true,
                                                         attendCount: 0,
                                                         absentCount: 0,
                                                         lateCount: 0)

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
    
    //apiを叩いて該当する授業を取得する
    func getJson(){
        //デバック用
        let urlString = "http://localhost:3000/apis/show/\(day)/\(selectedNumber/6 + 1)/\(faculty)"
        
        //本番用
        //let urlString = "https://qiita.com/api/v2/items"

        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URLComponents(string: encodeUrlString) else {return}
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in

            guard let _data = data else { return }
            // JSONデコード
            do {
                let classInformation = try JSONDecoder().decode([Information].self, from: _data)
                for row in classInformation {
                    print("title:\(row.title) teacher:\(row.teacher) credit:\(row.credit)")
                }
                //print(classInformation)
                self.informationIntoList(informationArray: classInformation)
                print("-------------")
                print(self.list)
                print("-------------")
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //trueならtextFieldの有効化,falseなら無効化
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
    
    //listに授業情報を入れる
    func informationIntoList(informationArray: Array<Information>){
        for info in informationArray{
            list += [info]
        }
    }
    
    //pickerを閉じる
    func closePicker(){
        UIView.animate(withDuration: 0.3) {
            self.vi.frame.origin.y += self.vi.bounds.size.height
        }
    }
    //pickerを開く
    func openPicker(){
        UIView.animate(withDuration: 0.3) {
            self.vi.frame.origin.y = self.screenSize.height - self.vi.bounds.size.height
        }
    }
}
