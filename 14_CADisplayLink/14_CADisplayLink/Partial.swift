//
//  Partial.swift
//  14_CADisplayLink
//
//  Created by Jz D on 2021/9/28.
//

import UIKit

class Partial: UIView {

    
    var animating = false
    
    var timer: CADisplayLink!
    
    let duration: TimeInterval
    
    var lastSelectedIndex: Int?
    var selectedIndex: Int?
    
    var count: TimeInterval
    let total: TimeInterval
    override init(frame: CGRect) {
        duration = 3
        total = duration * 20
        count = duration * 20
        super.init(frame: frame)
        timer = CADisplayLink(target: self, selector: #selector(Partial.tick))
        timer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    
    required init?(coder: NSCoder) {
        duration = 3
        total = duration * 20
        count = duration * 20
        super.init(coder: coder)
        timer = CADisplayLink(target: self, selector: #selector(Partial.tick))
        timer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    func startAnimation(_ idx: Int){
        guard selectedIndex != idx else { return }
        animating = true
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code

        let rest = total - count
        let progress: CGFloat = CGFloat(rest / total)
        let height = rect.height
        let topY: CGFloat = 100
        let deltaHeight = -1 * topY * progress
        
        // print("delta: \(deltaHeight)")
        
        let topLeft = CGPoint(x: 0, y: topY)
        let topMid = CGPoint(x: rect.width / 2, y: topY)
        let topRight = CGPoint(x: rect.width, y: topY)
        
        let fourthLhs = rect.width / 4
        let fourthRhs = rect.width * 3 / 4
        
        
        let bottomLeft = CGPoint(x: 0, y: height)
        let bottomRight = CGPoint(x: rect.width, y: height)
        let path = UIBezierPath()
        UIColor.blue.setFill()
        path.move(to: topLeft)
        path.addQuadCurve(to: topMid, controlPoint: CGPoint(x: fourthLhs, y: deltaHeight))
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        path.fill()
        
    }
    
    
    
    @objc func tick(){
        guard animating, count >= 0 else {
            animating = false
            return
        }
        count -= 1
        setNeedsDisplay()
    }
    

}
