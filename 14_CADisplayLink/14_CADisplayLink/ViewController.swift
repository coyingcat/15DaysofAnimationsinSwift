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

