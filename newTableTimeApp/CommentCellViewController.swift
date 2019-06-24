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
        
        //let parent = self.view.frame
 
        imageView.backgroundColor = .red
        
        imageView.isUserInteractionEnabled = true

        
        //evaluationStar.backgroundColor = .blue
        //evaluationLabel.backgroundColor = .yellow
        textView.contentOffset = CGPoint.zero

        
        
        
    }

}
