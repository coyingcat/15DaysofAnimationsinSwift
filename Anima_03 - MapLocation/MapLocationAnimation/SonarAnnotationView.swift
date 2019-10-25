//
//  Sonar.swift
//  MapLocationAnimation
//
//  Created by Larry Natalicio on 4/17/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit
import MapKit

class SonarAnnotationView: MKAnnotationView {
    
    // MARK: - Types
    
    
    struct ColorPalette {
        static let green = UIColor(red:0.00, green:0.87, blue:0.71, alpha:1.0)
    }
    

    
    // MARK: - Initializers
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        startAnimation()
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Convenience
    
    func sonar(_ beginTime: CFTimeInterval) {
        let circlePath1 = UIBezierPath(arcCenter: self.center, radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat.pi * 2, clockwise: true)

        let circlePath2 = UIBezierPath(arcCenter: self.center, radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat.pi * 2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = ColorPalette.green.cgColor
        shapeLayer.fillColor = ColorPalette.green.cgColor
        shapeLayer.path = circlePath1.cgPath
        self.layer.addSublayer(shapeLayer)
        
        
        // 两个动画
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = circlePath1.cgPath
        pathAnimation.toValue = circlePath2.cgPath
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.8
        alphaAnimation.toValue = 0
        
        // 组动画
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = beginTime
        animationGroup.animations = [pathAnimation, alphaAnimation]
        
        // 时间有讲究
        animationGroup.duration = 2.76
        
        // 不断重复
        animationGroup.repeatCount = Float.greatestFiniteMagnitude
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        
        // Add the animation to the layer.
        // key 用来 debug
        shapeLayer.add(animationGroup, forKey: "sonar")
    }
    
    func startAnimation() {
        // 三次动画，效果合成
        sonar(CACurrentMediaTime())
        sonar(CACurrentMediaTime() + 0.92)
        sonar(CACurrentMediaTime() + 1.84)
    }
    
}
