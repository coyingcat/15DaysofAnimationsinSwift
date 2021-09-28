//
//  Partial.swift
//  14_CADisplayLink
//
//  Created by Jz D on 2021/9/28.
//

import UIKit







class Partial: UIView {

    
    
    class Helper{
        let duration: TimeInterval
        var count: TimeInterval
        let total: TimeInterval
        
        init(lasting time: TimeInterval){
            duration = time
            total = time * 20
            count = time * 20
        }
        
        
        func reset(){
            count = total
        }
        
        var progressPositive: CGFloat{
            let rest = total - count
            return CGFloat(rest / total)
        }
        
        var progressNegative: CGFloat{
            return CGFloat(count / total)
        }
    }
    
    
    var animating = false
    var timer: CADisplayLink!
    
    var lastSelectedIndex: Int?
    var selectedIndex: Int?
    
    let helper: Helper
    
    var needsReset = false
    
    override init(frame: CGRect) {
        helper = Helper(lasting: 3)
        super.init(frame: frame)
        timer = CADisplayLink(target: self, selector: #selector(Partial.tick))
        timer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    
    required init?(coder: NSCoder) {
        helper = Helper(lasting: 3)
        super.init(coder: coder)
        timer = CADisplayLink(target: self, selector: #selector(Partial.tick))
        timer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    func startAnimation(_ idx: Int){
        guard selectedIndex != idx else { return }
        animating = true
        selectedIndex = idx
        helper.reset()
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code

        let height = rect.height
        let topY: CGFloat = 100
        var progress = helper.progressPositive
        if needsReset{
            progress = helper.progressNegative
        }
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
        switch lastSelectedIndex{
        case 0:
            path.addQuadCurve(to: topMid, controlPoint: CGPoint(x: fourthLhs, y: deltaHeight))
        case 1:
            path.addLine(to: topMid)
            path.addQuadCurve(to: topRight, controlPoint: CGPoint(x: fourthRhs, y: deltaHeight))
        default:
            ()
        }
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        path.fill()
        
    }
    
    
    
    @objc func tick(){
        guard animating, helper.count >= 0 else {
            if needsReset{
                lastSelectedIndex = selectedIndex
                helper.reset()
            }
            else{
                animating = false
            }
            return
        }
        helper.count -= 1
        setNeedsDisplay()
    }
    

}
