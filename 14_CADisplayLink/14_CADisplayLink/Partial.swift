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
    
    let duration: TimeInterval = 3
    
    var lastSelectedIndex: Int?
    var selectedIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timer = CADisplayLink(target: self, selector: #selector(JellyView.tick))
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        timer = CADisplayLink(target: self, selector: #selector(JellyView.tick))
    }
    
    func startAnimation(_ idx: Int){
        guard selectedIndex != idx else { return }
        animating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.animating = false
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let layer = layer.presentation() else { return }
        let to: CGFloat = 100
        let len: CGFloat = 100
        var progress: CGFloat = 1
        if animating{
            progress = 1 - (layer.position.y - to) / len
        }
        let height = rect.height
        let deltaHeight = height * (1 - abs(progress)) * 0.6
        
        // print("delta: \(deltaHeight)")
        
        let topLeft = CGPoint(x: 0, y: 0)
        let topMid = CGPoint(x: rect.width / 2, y: 0)
        let topRight = CGPoint(x: rect.width, y: 0)
        
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
        guard animating else {return}
        setNeedsDisplay()
    }
    

}
