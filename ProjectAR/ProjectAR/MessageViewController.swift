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
    var messageHideTimer: Timer? = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageView.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.layer.applyRoundCornerMaskWith(radius: messageView.frame.height/2, corners: [.topRight, .topLeft, .bottomRight])
    }
    
    // - MARK: Public API
    func clearScheduledMessage() {
        messageHideTimer?.invalidate()
        messageHideTimer = Timer()
        messages.removeAll()
        hideMessage()
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
        if messages.isEmpty {
            scheduleMessage(text, forDuration: seconds)
        } else {
            let message = (text, seconds)
            // Halt the timer
            messageHideTimer?.invalidate()
            messageHideTimer = Timer()
            
            messages.removeFirst()
            messages.insert(message, at: 0)
            displayMessage(text, forDuration: seconds)
        }
    }
    
    // - MARK: Private Functions
    private func displayMessage(_ message: String, forDuration seconds: TimeInterval) {
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
        
        // Creates a count down timer which will invalidate timer and hide the current message
        messageHideTimer?.invalidate()
        messageHideTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            self?.displayDuration -= 1
            if ((self?.displayDuration)! <= 0) {
                self?.hideMessage()
                timer.invalidate()
                
            }
        })
    }
    
    private func hideMessage() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                self.messageView.layer.opacity = 0
            }, completion: { _ in
                guard self.messages.isEmpty != true else { return }
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
