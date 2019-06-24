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
    var onboardStringArray = ["これは岩手大学生用の時間割アプリです。", "時間割アプリって打ち込むのが大変!", "そんな時にこのアプリ！", "自分が受講する時間割を探すだけ！", "また先輩たちが授業の評価/コメントを残してるかも？", "ぜひ使ってみてね!(他大学生も使えます)"]
    
    @IBOutlet var scrollView: UIScrollView!
    
    var animationArray = ["schedule", "busy", "app", "select", "comment", "use"]
    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        page = animationArray.count
        
        scrollView.isPagingEnabled = true
        scrollView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        setUpScroll()
        //アニメーションのviewを作る
        
        for i in 0..<page{
            
            let animationView = AnimationView()
            let animation = Animation.named(animationArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
            
        }
    }
    
    func setUpScroll(){
        
        
        //スクロールビューを貼り付ける
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 6, height: self.view.frame.size.height)
        
        for i in 0..<page{
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * self.view.frame.size.width, y: self.view.frame.height/3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            /*
            onboardLabel.numberOfLines = 0
            onboardLabel.sizeToFit()
            onboardLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            */
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            onboardLabel.textAlignment = .center
           
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
            
        }
    }


}

