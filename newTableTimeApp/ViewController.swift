//
//  ViewController.swift
//  newTableTimeApp
//
//  Created by 佐藤裕紀 on 2019/06/08.
//  Copyright © 2019 Yuki Sato. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    //説明文を入れた配列
    var onboardStringArray = ["これは岩手大学専用の時間割です。", "既存の時間割アプリだと時間割を打ち込むのが大変", "そんな時にこのアプリ！", "自分が受講する時間割を探すだけ！", "ぜひ使ってみてね!"]
    
    @IBOutlet var scrollView: UIScrollView!
    
    var animationArray = ["schedule", "busy", "app", "select", "use"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isPagingEnabled = true
        
        setUpScroll()
        //アニメーションのviewを作る
        
        for i in 0...4{
            
            let animationView = AnimationView()
            let animation = Animation.named(animationArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
            
        }
    }
    
    func setUpScroll(){
        //スクロールビューを貼り付ける
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: view.frame.size.height)
        
        for i in 0...4{
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * self.view.frame.size.width, y: self.view.frame.height/3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
            
        }
    }


}

