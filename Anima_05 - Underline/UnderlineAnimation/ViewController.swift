//
//  ViewController.swift
//  UnderlineAnimation
//
//  Created by Larry Natalicio on 4/20/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    // MARK: - Types
    
        struct ConstraintIdentifiers {
            static let centerLeftConstraintIdentifier = "centerLeftConstraintIdentifier"
            static let centerRightConstraintIdentifier = "centerRightConstraintIdentifier"
            static let widthConstraintIdentifier = "widthConstraintIdentifier"
        }
  
    
    enum Side {
        case left
        case right
    }
    
    // MARK: - Properties
    
    @IBOutlet var optionsBar: UIStackView!
    
    var underlineView: Underline!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUnderlineView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* 
        The frame is not correct when I call (optionsBar.frame.width / 2) in viewWillAppear.
        Therefore, I update the width constraint to this here.
        This also updates the constraint when the view rotates.
        */
        for constraint in underlineView.constraints {
            if constraint.identifier == ConstraintIdentifiers.widthConstraintIdentifier {
                constraint.constant = (optionsBar.frame.width / 2.5)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func goLeft(_ sender: UIButton) {
        
        animateContraintsForUnderlineView(underlineView, toSide: .left)
    }
    
    @IBAction func goRight(_ sender: UIButton) {
        
        animateContraintsForUnderlineView(underlineView, toSide: .right)
    }
    
    // MARK: - Convenience
    
    func setupUnderlineView() {
        underlineView = Underline()
        self.view.addSubview(underlineView)
        // 都是布局啊
        let topConstraint = underlineView.topAnchor.constraint(equalTo: optionsBar.bottomAnchor)
        let heightConstraint = underlineView.heightAnchor.constraint(equalToConstant: 2)
        
        let leftButton = optionsBar.arrangedSubviews[0]
        let centerLeftConstraint = underlineView.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor)
        
        
        // 这一手，很有意思
        centerLeftConstraint.identifier = ConstraintIdentifiers.centerLeftConstraintIdentifier
        
        // The frame is not set here correctly so I update this value again in viewDidLayoutSubviews.
        let widthConstraint = underlineView.widthAnchor.constraint(equalToConstant: (optionsBar.frame.width / 2.5))
        widthConstraint.identifier = ConstraintIdentifiers.widthConstraintIdentifier
        
        NSLayoutConstraint.activate([topConstraint, heightConstraint, widthConstraint, centerLeftConstraint])
    }
    
    func animateContraintsForUnderlineView(_ underlineView: UIView, toSide: Side) {
        
        switch toSide {
        case .left:
            
            for constraint in underlineView.superview!.constraints {
                if constraint.identifier == ConstraintIdentifiers.centerRightConstraintIdentifier {
                    
                    constraint.isActive = false
                    
                    let leftButton = optionsBar.arrangedSubviews[0]
                    let centerLeftConstraint = underlineView.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor)
                    centerLeftConstraint.identifier = ConstraintIdentifiers.centerLeftConstraintIdentifier
                    
                    NSLayoutConstraint.activate([centerLeftConstraint])
                }
            }
            
        case .right:
            
            for constraint in underlineView.superview!.constraints {
                if constraint.identifier == ConstraintIdentifiers.centerLeftConstraintIdentifier {
                    // 先失效，旧的约束
                    constraint.isActive = false
                    // 再新建约束，并激活
                    let rightButton = optionsBar.arrangedSubviews[1]
                    let centerRightConstraint = underlineView.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor)
                    centerRightConstraint.identifier = ConstraintIdentifiers.centerRightConstraintIdentifier
                    
                    NSLayoutConstraint.activate([centerRightConstraint])
                    
                }
            }
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.barTintColor = ColorPalette.green
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
}

