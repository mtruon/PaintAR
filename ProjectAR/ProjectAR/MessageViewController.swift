//
//  MessageViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-31.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var displayDuration: TimeInterval = 5.0
    
    // Timer for hiding messages.
    private var messageHideTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.layer.applyRoundCornerMaskWith(radius: messageView.frame.height/2, corners: [.topRight, .topLeft, .bottomRight])
    }
    
    func showMessage(_ message: String) {
        messageLabel.text = message
        messageView.isHidden = false
        messageView.layer.opacity = 1
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.duration = 1.0
        fadeAnimation.isRemovedOnCompletion = true
        
        let transition = CATransition()
        transition.type = CATransitionType.moveIn
        transition.isRemovedOnCompletion = true
        transition.duration = 0.2
        
        messageView.layer.add(transition, forKey: nil)
        messageView.layer.add(fadeAnimation, forKey: nil)
        
        CATransaction.commit()
        
        messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
            self?.hideMessage()
        })
    }
    
    func hideMessage() {
        UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
            self.messageView.layer.opacity = 0
        }, completion: { _ in
            self.messageView.isHidden = true
        })
    }
    
    func displayMessage(_ message: String, forDuration seconds: TimeInterval) {
        // Cancel or stop a message from being sent
        messageHideTimer?.invalidate()
        
        self.displayDuration = seconds
        showMessage(message)
    }
    
}

extension CALayer {
    
    func applyRoundCornerMaskWith(radius: CGFloat, corners: UIRectCorner) {
        let path:UIBezierPath = UIBezierPath(roundedRect: self.bounds,
                                             byRoundingCorners: corners,
                                             cornerRadii: CGSize(width: radius,height: radius))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.frame = self.bounds
        self.mask = layer
    }
}
