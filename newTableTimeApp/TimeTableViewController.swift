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
    
    let date = ["月","火","水","木","金"]
    var dateLabel: UILabel?
    var hourLabel: UILabel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if(section == 0){
            return 5 + 1
        }else{
            return 30 + 6
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) // 表示するセルを登録
        
        if(indexPath.section == 0){
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .magenta
            
            /* 曜日のとこのcellの設定 */
            if(indexPath.row % 6 != 0){
                dateLabel = UILabel(frame: CGRect(x:0, y:0, width: collectionView.bounds.width/5 - 5, height: 13))
                //cell.backgroundColor = .magenta
                dateLabel?.text = date[indexPath.row - 1]
                dateLabel?.textAlignment = .center
                cell.contentView.addSubview(dateLabel!)
            }
            
        }else{
            cell.backgroundColor = .darkGray  // セルの色
            
            
            
            
            /* ここはコマ数を書くところのcellの設定 */
            if(indexPath.row % 6 == 0){
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .lightGray
                hourLabel = UILabel(frame: CGRect(x:0, y:0, width: 15, height: collectionView.bounds.width/5 + 10))
                hourLabel?.text = String(indexPath.row / 6 + 1)
                hourLabel?.textAlignment = .center
                cell.contentView.addSubview(hourLabel!)
            }
        }
        
        return cell
        
    }
    
    //cellのサイズを変更
    //まだできてない
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize
        
        let cellWidth = (collectionView.bounds.width / 5) - 5
        
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
    }
    
    //コレクションビューのセクション数　今回は2つに分ける
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self


        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            //let cellWidth = floor(collectionView.bounds.width / 5) - 5 // *5列*
            
            //layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 15)
            // ここからはオプション マージンとかをなくしている
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
            layout.minimumInteritemSpacing = 2// アイテム間?
            //layout.minimumLineSpacing = CGFloat(1) // 行間
            
        }
        
        
    }

}
