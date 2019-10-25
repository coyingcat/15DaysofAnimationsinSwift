//
//  FadingLabel.swift
//  SecretTextAnimation
//
//  Created by Larry Natalicio on 4/27/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit


typealias Completion = ((_ finished: Bool) -> Void)?


class FadingLabel: CharacterLabel {
    
    // MARK: - Properties

    override var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        }
        set {
            super.attributedText = newValue
            self.animateIn { (finished) in
                self.animateIn(nil)
            }
        }
    }
    
    
    
    override func initialTextLayerAttributes(_ textLayer: CATextLayer) {
        textLayer.opacity = 0
    }
    
    
    
    
    
    
    
    
    // MARK: - Convenience
    // 出现
    func animateIn(_ completion: Completion) {
        for textLayer in characterTextLayers {
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
            
            CLMLayerAnimation.animation(textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 1
            }, completion: nil)
        }
    }

    
    
    
    // 消失
    func animateOut(_ completion: Completion){
        var longestAnimation = 0.0
        var longestAnimationIndex = -1
        var index = 0
        
        for textLayer in oldCharacterTextLayers {
            
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
            
            if duration+delay > longestAnimation {
                longestAnimation = duration + delay
                longestAnimationIndex = index
            }
            
            
            
            
            CLMLayerAnimation.animation(textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 0
            }, completion: { finished in
                textLayer.removeFromSuperlayer()
                if textLayer == self.oldCharacterTextLayers[longestAnimationIndex] {
                    if let completionFunction = completion {
                        completionFunction(finished)
                    }
                }
            })
            
            index += 1
        }
    }
}
