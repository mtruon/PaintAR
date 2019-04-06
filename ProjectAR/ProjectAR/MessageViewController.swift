//
//  MessageViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-31.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var displayDuration: TimeInterval = 5.0
    
    private var messages: [(String, TimeInterval)] = []
    
    // A Timers for hiding messages.
    var messageHideTimer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.layer.applyRoundCornerMaskWith(radius: messageView.frame.height/2, corners: [.topRight, .topLeft, .bottomRight])
    }
    
    func clearScheduledMessage() {
        for i in (0..<messages.count).reversed() {
            messages.remove(at: i)
        }
    }
    
    func scheduleMessage(_ text: String, forDuration seconds: TimeInterval) {
        let message = (text, seconds)
        messages.append(message)
        
        // If only one message exists then we start the queue by displaying the first message
        if messages.count == 1 {
            displayMessage(text, forDuration: seconds)
        }
    }
    
    /// Replaces and schedules a new message to be displayed immediately
    func scheduleMessageImmediately(_ text: String, forDuration seconds: TimeInterval) {
        let message = (text, seconds)
        
        if !messages.isEmpty {
            messages.insert(message, at: 1)
        } else {
            messages.append(message)
        }
        
        displayMessage(<#T##message: String##String#>, forDuration: <#T##TimeInterval#>)
    }
    
    private func displayMessage(_ message: String, forDuration seconds: TimeInterval) {
        // Cancel or stop a message from being sent
        messageHideTimer?.invalidate()
        
        self.displayDuration = seconds
        showMessage(message)
    }
    
    // - MARK: Message Animations and Transitions
    private func showMessage(_ message: String) {
        DispatchQueue.main.async {
            self.messageLabel.text = message
            self.messageView.isHidden = false
            self.messageView.layer.opacity = 1
        }
        
        // Animating the transition and fade in
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
    
    private func hideMessage() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                self.messageView.layer.opacity = 0
            }, completion: { _ in
                self.messageView.isHidden = true
                
                // Remove the message was just displayed from the queue
                self.messages.removeFirst()
                
                // If the queue contains additional messages then display the new head
                if !self.messages.isEmpty {
                    if let upcomingMessage = self.messages.first {
                        self.displayMessage(upcomingMessage.0, forDuration: upcomingMessage.1)
                    }
                }
            })
        }
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
