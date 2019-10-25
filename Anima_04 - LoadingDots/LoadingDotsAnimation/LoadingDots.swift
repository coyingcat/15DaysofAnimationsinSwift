//
//  LoadingDots.swift
//  LoadingDotsAnimation
//
//  Created by Larry Natalicio on 4/19/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingDots: UIView {
    
    // MARK: - Properties
    
    let logo = UIImageView(image: UIImage(named: "logo"))
    
    var dotOne = UIImageView(image: UIImage(named: "dot"))
    var dotTwo = UIImageView(image: UIImage(named: "dot"))
    var dotThree = UIImageView(image: UIImage(named: "dot"))
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup(){
        
        // 布局部分
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logo)

        let logoCenterX = logo.centerXAnchor.constraint(equalTo: centerXAnchor)
        let logoTop = logo.topAnchor.constraint(equalTo: topAnchor)

        let logo_width = logo.widthAnchor.constraint(equalToConstant: 126)
        let logo_height = logo.heightAnchor.constraint(equalToConstant: 126.0 * 112.0 / 402.0)
        
        
        
        let dots = [dotOne, dotTwo, dotThree]

    
        NSLayoutConstraint.activate([logo_width, logo_height, logoCenterX, logoTop])
        
        dots.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
            let dot_width = $0.widthAnchor.constraint(equalToConstant: 10)
            let dot_height = $0.heightAnchor.constraint(equalToConstant: 10)
            let dot_top = $0.topAnchor.constraint(equalTo: logo.bottomAnchor , constant:  10)
            NSLayoutConstraint.activate([dot_width, dot_height, dot_top])
        }
        
        let dotOneLeading = dotOne.leadingAnchor.constraint(equalTo: logo.leadingAnchor)
        let dotTwoCenter = dotTwo.centerXAnchor.constraint(equalTo: centerXAnchor)
        let dotThreeTrailing = dotThree.trailingAnchor.constraint(equalTo: logo.trailingAnchor)
        NSLayoutConstraint.activate([dotOneLeading, dotTwoCenter, dotThreeTrailing])
        
        // 动画部分
        
        // Listen for UIApplicationDidBecomeActiveNotification notification to resume
        // animation when the app returns from the background.
        registerForNotifications()
        startAnimation()
    }

    
    // MARK: - Lifetime
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Convenience
    
    func startAnimation() {
    
        dotOne.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dotTwo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dotThree.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        
        // 三个不同的 delay, 渐进时间
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.dotOne.transform = CGAffineTransform.identity
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.dotTwo.transform = CGAffineTransform.identity
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.dotThree.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    // MARK: - Notifications
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoadingDots.applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc
    func applicationDidBecomeActive(_ notification: Notification) {
        startAnimation()
    }
    
}
