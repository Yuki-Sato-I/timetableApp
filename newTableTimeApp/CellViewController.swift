//
//  CellViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/13.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

class CellViewController: UIViewController, AlertHelper {

    //エンコーダー
    let encoder = JSONEncoder()
    //授業情報
    struct ClassInfo: Codable{
        var id:Int = -1000
        var title:String = "登録されていません"
        var teacher:String = "登録されていません"
        var credit:Int = 0
        var day:String = "Monday"
        var faculty:String = "理工学部"
        var specialty:Bool = true
        var attendCount:Int = 0
        var absentCount:Int = 0
        var lateCount:Int = 0
    }
    //初期化
    var classInfo = ClassInfo()
    
    //曜日ラベル
    let dateLabelArray = ["月曜","火曜","水曜","木曜","金曜"]
    let dateLabelEnglishArray = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    let hourLabelArray = ["1コマ目","2コマ目","3コマ目","4コマ目","5コマ目","6コマ目"]
    //ボタンのラベル名
    let buttonLabelArray = ["出席", "欠席", "遅刻"]
    //遷移しながら渡されるcell番号
    var selectedNumber: Int = 0
    
    //出席回数
    var attendCount: Int = 0
    //欠席回数
    var absentCount: Int = 0
    //遅刻回数
    var lateCount: Int = 0

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleContent: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var teacherContent: UILabel!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var creditContent: UILabel!
    
    @IBOutlet var classEvaluation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dateLabelArray[selectedNumber % 6 - 1] + hourLabelArray[selectedNumber / 6]
        //すでに登録されていたらその授業の情報をのせる
        if (UserDefaults.standard.object(forKey: String(selectedNumber)) != nil){
            if let savedClassInfo = UserDefaults.standard.object(forKey: String(selectedNumber)) as? Data {
                let decoder = JSONDecoder()
                if let c = try? decoder.decode(ClassInfo.self, from: savedClassInfo) {
                    classInfo = c
                }
            }
        }
        
        attendCount = classInfo.attendCount
        absentCount = classInfo.absentCount
        lateCount = classInfo.lateCount
        
        titleContent.text = classInfo.title
        teacherContent.text = classInfo.teacher
        creditContent.text = String(classInfo.credit)

 
        let screenWidth = self.view.frame.width
        
        for i in 0..<3 {
            // UIButtonのインスタンスを作成する
            let button = UIButton(type: UIButton.ButtonType.system)
            // ボタンを押した時に実行するメソッドを指定
            button.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
            // ラベルを設定する
            button.setTitle(buttonLabelArray[i], for: UIControl.State.normal)
            
            button.frame = CGRect(x: CGFloat(screenWidth/3 * CGFloat(i)), y: 300, width: screenWidth/3, height: 50)
            button.backgroundColor = .red
            // viewに追加する
            self.view.addSubview(button)

            let label = UILabel()
            label.frame = CGRect(x: CGFloat(screenWidth/3 * CGFloat(i)), y: 350, width: screenWidth/3, height: 100)
            label.textAlignment = .center
            //tag付け
            label.tag = i + 100
            label.backgroundColor = .blue
            self.view.addSubview(label)
        }
        
        for i in 0..<3 {
            let label = self.view.viewWithTag(100+i) as! UILabel
            if(i == 0){
                label.text = String(classInfo.attendCount)
            }else if(i == 1){
                label.text = String(classInfo.absentCount)
            }else{
                label.text = String(classInfo.lateCount)
            }
        }
        
        
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: String(selectedNumber)) != nil){
            
            if let savedClassInfo = UserDefaults.standard.object(forKey: String(selectedNumber)) as? Data {
                let decoder = JSONDecoder()
                if let c = try? decoder.decode(ClassInfo.self, from: savedClassInfo) {
                    classInfo = c
                }
            }
            
            if(sender.currentTitle == "出席"){
                attendCount += 1
                let label = self.view.viewWithTag(100) as! UILabel
                label.text = String(attendCount)
                classInfo.attendCount = attendCount
            }else if(sender.currentTitle == "欠席"){
                absentCount += 1
                let label = self.view.viewWithTag(101) as! UILabel
                label.text = String(absentCount)
                classInfo.absentCount = absentCount
            }else{
                lateCount += 1
                let label = self.view.viewWithTag(102) as! UILabel
                label.text = String(lateCount)
                classInfo.lateCount = lateCount
            }
            
            
            if let encoded = try? encoder.encode(classInfo) {
                UserDefaults.standard.set(encoded, forKey: String(selectedNumber))
            }
            print("出席回数: \(attendCount) 欠席回数: \(absentCount) 遅刻回数: \(lateCount)")
        }

    }
    
    //値渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configSegue"{
            let configVc: ConfigViewController = segue.destination as! ConfigViewController
            
            //configVc.classInfo = classInfo
            configVc.day = dateLabelEnglishArray[selectedNumber % 6 - 1]
            configVc.selectedNumber = selectedNumber
            
        }else if(segue.identifier == "evaluationSegue"){
            let commentVc: CommentViewController = segue.destination as! CommentViewController
            
            commentVc.classId = classInfo.id
        }
    }
    
    //戻ってきたときの画面リロード
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadView()
        viewDidLoad()
    }
    
    @IBAction func goToCommentPage(_ sender: Any) {
        if(classInfo.id == -999){
            self.makeAndShowAlert(errorTitle: "エラー", errorMessage: "この授業は自分で入力したものです.", viewController: self)
        }else if(classInfo.id == -1000){
            self.makeAndShowAlert(errorTitle: "エラー", errorMessage: "まだ授業を登録していません.", viewController: self)
        }
    }
    
}

//UILabelにボーダーラインを追加するための拡張
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}
