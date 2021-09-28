//
//  ViewController.swift
//  14_CADisplayLink
//
//  Created by Jz D on 2021/9/28.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var jelly: JellyView!
    
    
    
    @IBOutlet weak var partial: Partial!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer()
        partial.addGestureRecognizer(tap)
        partial.isUserInteractionEnabled = true
        partial.clipsToBounds = false
        tap.addTarget(self, action: #selector(ViewController.tap(with:)))
        
        
        partial.layer.debug()
        jelly.layer.debug()
        
    }
    
    
    
    
    @objc func tap(with gesture: UITapGestureRecognizer){
        guard !jelly.animating else{ return }
        let point = gesture.location(in: partial)
        let width = partial.frame.width
        let isRight = point.x > width / 2
        let idx = isRight ? 1 : 0
        partial.backgroundColor = UIColor.clear
        partial.startAnimation(idx)
    }
    
    
    

    @IBAction func toAnimate(_ sender: Any) {
        
        guard !jelly.animating else{ return }
        let from = view.bounds.height - jelly.bounds.height / 2
        let to: CGFloat = 100
        jelly.backgroundColor = UIColor.clear
        jelly.center = CGPoint(x: jelly.center.x, y: from)
        jelly.startAnimation(from, to)
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: []) {
            self.jelly.center = CGPoint(x: self.jelly.center.x, y: to)
        } completion: { _ in
            self.jelly.completeAnimation()
        }
    }
    
}




extension CALayer{
    func debug(){
        borderColor = UIColor.red.cgColor
        borderWidth = 5
    }
}
