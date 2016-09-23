//
//  ViewController.swift
//  UIViewPropertyAnimatorDemo
//
//  Created by GMobile No.2 on 16/9/21.
//  Copyright © 2016年 王灿辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var animator = UIViewPropertyAnimator()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let circleRadius : CGFloat = 35
    private var circleView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCircleView()
        // 先玩一下之前的UIView动画
        /**
         Damping 阻尼系数
         initialSpringVelocity 初始速度
         options 设置时间与进度的贝塞尔曲线类型（枚举）
         */
        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveLinear, animations: {
            self.circleView.transform = CGAffineTransform(translationX: self.screenWidth-2*self.circleRadius ,y: 0)
            }) { (_) in
                
        }
    }
    
    private func setupCircleView(){
        circleView = UIView(frame: CGRect(x: 0, y: screenHeight*0.5, width: 2*circleRadius, height: 2*circleRadius))
        circleView.backgroundColor = UIColor.cyan
        circleView.layer.cornerRadius = circleRadius
        self.view.addSubview(circleView)
    }
    // 暂停
    @IBAction func pauseAnimation() {
        if animator.state == .active {
            animator.pauseAnimation()
            print(animator.state.rawValue)
        }
    }
    // 继续
    @IBAction func resumeAnimaiton() {
        if animator.state == .active{
            // startAnimation 或者 continueAnimation 都可以是使未结束的动画继续执行
//            animator.startAnimation()
            animator.continueAnimation(withTimingParameters: nil, durationFactor: animator.fractionComplete)
            print(animator.state.rawValue)
        }
    }
    // 反向
    @IBAction func reverseAnimation() {
        if animator.state == .active{
            animator.isReversed = true
        }

    }
    // 停止（结束动画）
    @IBAction func stopAnimation() {
        if animator.state == .active{
            animator.stopAnimation(true)
            print(animator.state.rawValue)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var alertVC : UIAlertController!
        if UIDevice.current.model != "iPhone" {
            alertVC = UIAlertController(title: "请选择想看的", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        }else{
            alertVC = UIAlertController(title: "请选择想看的", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        }
        alertVC.addAction(UIAlertAction(title: "bezierSystemAnimation", style: UIAlertActionStyle.default) { (_) in
            self.bezierSystemAnimation()
        })
        alertVC.addAction(UIAlertAction(title: "bezierCustomAnimation1", style: UIAlertActionStyle.default) { (_) in
            self.bezierCustomAnimation1()
        })
        alertVC.addAction(UIAlertAction(title: "bezierCustomAnimation2", style: UIAlertActionStyle.default) { (_) in
            self.bezierCustomAnimation2()
        })
        alertVC.addAction(UIAlertAction(title: "dampingSystemAnimation", style: UIAlertActionStyle.default) { (_) in
            self.dampingSystemAnimation()
        })
        alertVC.addAction(UIAlertAction(title: "dampingCustomeAnimation", style: UIAlertActionStyle.default) { (_) in
            self.dampingCustomeAnimation()
        })
        
        self.present(alertVC, animated: true, completion: nil)
        
        // 复原
        if animator.state == .active {
            animator.stopAnimation(true)
        }
        self.circleView.transform = CGAffineTransform(translationX: 0, y: 0)
        if self.circleView.alpha < 1.0 {
            self.circleView.alpha = 1.0
            self.circleView.center.x = self.circleRadius
        }
    }
    
    /// 贝塞尔曲线（系统）
    private func bezierSystemAnimation(){
        /*
         case easeInOut // slow at beginning and end
         case easeIn // slow at beginning
         case easeOut // slow at end
         case linear // 匀速
         */
        animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: {
            self.circleView.transform = CGAffineTransform(translationX: self.screenWidth-2*self.circleRadius ,y: 0)
        })
        print("开始前：",animator.state.rawValue)
        animator.startAnimation()
    //      animator.pauseAnimation() // 可以试一下用pauseAnimation让animator的状态由inactive 变为 active ，再点击继续即可开始动画
        print("开始后：",animator.state.rawValue)
        
    }
    
    /**
     自定义贝塞尔曲线(时间与进度)
     时间 x, 进度 y
     */
    private func bezierCustomAnimation1(){
        
        animator = UIViewPropertyAnimator(duration: 3, controlPoint1: CGPoint(x: 0.2, y: 0.8), controlPoint2: CGPoint(x: 0.2, y: 0.8), animations: {
            self.circleView.transform = CGAffineTransform(translationX: self.screenWidth-2*self.circleRadius ,y: 0)
        })
        animator.startAnimation()
    }
    
    /**
     自定义贝塞尔曲线(时间与进度)
     时间 x, 进度 y
     */
    private func bezierCustomAnimation2(){
        
        let bezierParams = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.2, y: 0.8), // x,y是0~1.0的小数
            controlPoint2: CGPoint(x: 0.2, y: 0.8))
        
        animator = UIViewPropertyAnimator(duration: 3, timingParameters: bezierParams)
        
        animator.addAnimations {
            self.circleView.transform = CGAffineTransform(scaleX: 3, y: 3)
        }
        
        animator.addAnimations {
            self.circleView.transform = CGAffineTransform(translationX: self.screenWidth-2*self.circleRadius ,y: 0)
        }
        animator.startAnimation()
    }
   
    /// 阻尼振动(系统)
    private func dampingSystemAnimation(){
        animator = UIViewPropertyAnimator(duration: 3, dampingRatio: 0.1, animations: {
             self.circleView.transform = CGAffineTransform(translationX: self.view.center.x-self.circleRadius ,y: 0)
        })
        animator.startAnimation()
    }
    
    /// 阻尼振动（完全自定义）
    private func dampingCustomeAnimation(){
    
        /*
         mass 质量参数
         stiffness 劲度系数（弹性系数） 描述单位形变量时所产生弹力的大小，F = K * △X (F为弹力，K是劲度系数，△x是弹簧形变量)
         damping  阻尼系数 1.欠阻尼（取值范围0~1.0 ，值越小振动效果越明显） 2.临界阻尼 取值为1  3.过阻尼（取值范围>1 ，值越大振动越不明显）
         initialVelocity 初始速度（矢量，值越大速度越快）
         */
        
        let velocity = CGVector(dx: 1, dy: 1)
        let springParameters = UISpringTimingParameters(mass: 3, stiffness: 20, damping: 1, initialVelocity: velocity)
        animator = UIViewPropertyAnimator(duration: 0.25, timingParameters: springParameters)
        
        self.circleView.center = self.view.center
        
        animator.addAnimations {
            self.circleView.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.circleView.alpha = 0.2
        }
        
        animator.startAnimation()
        // 动画结束的时候回调
        animator.addCompletion { (position) in
            print("Completion:",position.rawValue)
            self.circleView.alpha = 1.0
            self.circleView.center.x = self.circleRadius
            self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}

