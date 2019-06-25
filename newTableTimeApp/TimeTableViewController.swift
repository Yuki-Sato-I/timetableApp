//
//  TimeTableViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/09.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var classInfo = CellViewController.ClassInfo()
   
    let date = ["月","火","水","木","金"]
    
    //選択されたcell番号
    var count = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if(section == 0){
            return 5 + 1
        }else{
            return 30 + 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        // 表示するセルを登録
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath)
        
        /* ここでcellの初期化cellが再利用されるため */
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.isUserInteractionEnabled = true
        
        if(indexPath.section == 0){
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .magenta
            
            /* 曜日のとこのcellの設定 */
            if(indexPath.row % 6 != 0){
                let dateLabel = UILabel(frame: CGRect(x:0, y:0, width: collectionView.bounds.width/5 - 1, height: 13))
                dateLabel.text = date[indexPath.row - 1]
                dateLabel.textAlignment = .center
                
                cell.contentView.addSubview(dateLabel)
            }
            
        }else{

            if(indexPath.row % 6 != 0){
                
                cell.backgroundColor = .darkGray  // セルの色
                
                let classTitle = UILabel(frame: CGRect(x:0, y:0, width: cell.bounds.width, height: cell.bounds.height/3))
                classTitle.textAlignment = .center
                classTitle.font = classTitle.font.withSize(10)
            
                if (UserDefaults.standard.object(forKey: String(indexPath.row)) != nil){
                    if let savedClassInfo = UserDefaults.standard.object(forKey: String(indexPath.row)) as? Data {
                        let decoder = JSONDecoder()
                        if let c = try? decoder.decode(CellViewController.ClassInfo.self, from: savedClassInfo) {
                            classInfo = c
                        }
                    }
                    classTitle.text = classInfo.title
                }else{
                    classTitle.text = "空き"
                }
                cell.contentView.addSubview(classTitle)
                
            }else{ /* ここはコマ数を書くところのcellの設定 */
                
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .lightGray
                
                let hourLabel = UILabel(frame: CGRect(x:0, y:0, width: 15, height: collectionView.bounds.width/5 + 14))
                hourLabel.text = String(indexPath.row / 6 + 1)
                hourLabel.textAlignment = .center
                cell.contentView.addSubview(hourLabel)
                
            }
            
        }
        
        return cell
        
    }

    //cellのサイズを変更
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize: CGSize
        
        let cellWidth: CGFloat = (collectionView.frame.width - 15.0) / 5.0 - 1.01
        print(cellWidth)
        if(indexPath.section == 0){
            cellSize = CGSize(width: cellWidth, height: 15)
            if(indexPath.row % 6 == 0){
               cellSize = CGSize(width: 15, height: 15)
            }
        }else{
            cellSize = CGSize(width: cellWidth, height: cellWidth + 15)
            if(indexPath.row % 6 == 0){
                cellSize = CGSize(width: 15, height: cellWidth + 15)
            }
        }
        
        return cellSize
    }
    
    //Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.section == 1 && indexPath.row % 6 != 0){
            print("Num: \(indexPath.row)")
        }
    
        //performSegue(withIdentifier: "selectedCell", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        count = Int(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedCell"{
            let cellVc: CellViewController = segue.destination as! CellViewController
            
            cellVc.selectedNumber = count
        }

    }
    

    
    //コレクションビューのセクション数　今回は2つに分ける
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print(collectionView.frame.width)
        


        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            //let cellWidth = floor(collectionView.bounds.width / 5) - 5 // *5列*
            
            //layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 15)
            // ここからはオプション マージンとかをなくしている
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
            layout.minimumLineSpacing = 1// アイテム間?
            layout.minimumInteritemSpacing = 1
            
            
        }
        
    }
    
    //戻ってきたときの画面リロード
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
    }

}
