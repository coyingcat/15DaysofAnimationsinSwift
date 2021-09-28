//
//  JellyView.swift
//  14_CADisplayLink
//
//  Created by Jz D on 2021/9/28.
//

import UIKit

class Helper{
    
    let displayLink: CADisplayLink
    let from: CGFloat
    let to: CGFloat
    let len: CGFloat
    
    internal init(displayLink: CADisplayLink, from: CGFloat, to: CGFloat) {
        self.displayLink = displayLink
        self.from = from
        self.to = to
        self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
        len = from - to
    }
}


class JellyView: UIView {
    
    var animating = false
    
    var helper: Helper?
    
    func startAnimation(_ from: CGFloat, _ to: CGFloat){
        animating = true
        helper = Helper(displayLink: CADisplayLink(target: self, selector: #selector(JellyView.tick)), from: from, to: to)
    }
    
    
    func completeAnimation(){
        animating = false
        helper?.displayLink.invalidate()
        helper = nil
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let info = helper, let layer = layer.presentation() else { return }
        
        var progress: CGFloat = 1
        if animating{
            progress = 1 - (layer.position.y - info.to) / (info.len)
        }
        let height = rect.height
        let deltaHeight = height * (1 - abs(progress)) * 0.6
        
        // print("delta: \(deltaHeight)")
        
        let topLeft = CGPoint(x: 0, y: deltaHeight)
        let topRight = CGPoint(x: rect.width, y: deltaHeight)
        let bottomLeft = CGPoint(x: 0, y: height)
        let bottomRight = CGPoint(x: rect.width, y: height)
        let path = UIBezierPath()
        UIColor.blue.setFill()
        path.move(to: topLeft)
        path.addQuadCurve(to: topRight, controlPoint: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: bottomRight)
        path.addQuadCurve(to: bottomLeft, controlPoint: CGPoint(x: rect.midX, y: height - deltaHeight))
        path.close()
        path.fill()
        
    }
    
    
    
    @objc func tick(){
        setNeedsDisplay()
    }


}
