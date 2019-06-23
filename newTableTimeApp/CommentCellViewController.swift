//
//  CommentCellViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/23.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit
import Cosmos

class CommentCellViewController: UIViewController {

    //選ばれたcellの評価情報
    var evaluation:CommentViewController.Evaluation!
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var evaluationLabel: UILabel!
    @IBOutlet var evaluationStar: CosmosView!
    //@IBOutlet var entireView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //textView.text = evaluation.content
        
        evaluationStar.settings.updateOnTouch = false
        evaluationStar.settings.fillMode = .half
        evaluationStar.rating = evaluation.star
        
        let parent = self.view.frame
 
        //imageView.frame = CGRect(x: 0, y: parent.height/8, width: parent.width - 50, height: parent.height * 4/7)
        //imageView.frame.height = parent.height * 4/7
        imageView.backgroundColor = .red
        imageView.center.x = self.view.center.x
        imageView.isUserInteractionEnabled = true
        
        evaluationLabel.frame = CGRect(x: parent.width/15, y: parent.height/13 - 20, width: parent.width*7/10, height: 20)
        evaluationStar.frame = CGRect(x: parent.width/15, y: parent.height/13, width: parent.width*7/10, height: 25)
        textView.frame = CGRect(x: parent.width/15, y: parent.width*3/13, width: parent.width*7/10, height: parent.height*3/10)
        
        //evaluationLabel.center.x = self.view.center.x
        //evaluationStar.center.x = self.view.center.x
        //textView.center.x = self.view.center.x
        
        
        imageView.addSubview(evaluationLabel)
        imageView.addSubview(evaluationStar)
        imageView.addSubview(textView)
        
        
        
    }

}
