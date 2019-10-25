//
//  LoadingLabel.swift
//  GradientAnimation
//
//  Created by Larry Natalicio on 4/23/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingLabel: UIView {
    
    struct Fonts {
        static let loadingLabel = "HelveticaNeue-UltraLight"
    }


    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // 灰， 白， 灰
        let colors = [UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.gray.cgColor]
        gradientLayer.colors = colors
        
        let locations = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations as [NSNumber]?
        
        return gradientLayer
    }()
    
    
    let textAttributes: [NSAttributedString.Key: AnyObject] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        return [NSAttributedString.Key.font: UIFont(name: Fonts.loadingLabel, size: 70.0)!, NSAttributedString.Key.paragraphStyle: style]
    }()
    
    // 文字转图片，然后绘制到视图上
    @IBInspectable var text: String! {
        didSet {
            setNeedsDisplay()
            
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            text.draw(in: bounds, withAttributes: textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 从文字中，抽取图片
            
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image?.cgImage
            
            gradientLayer.mask = maskLayer
        }
    }
    
    // 设置位置与尺寸
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 2 * bounds.size.width, height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        layer.addSublayer(gradientLayer)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 1.7
        
        // 一直循环
        gradientAnimation.repeatCount = Float.infinity
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

}
