//
//  DismissAnimator.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-06-06.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {
    
}

// MARK: - UIViewControllerAnimatedTransitioning protocol
extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        // Computes the final frame rectangle to be drawn for animation
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        // Animates the movement of the current frame (rectangle) to the final frame
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromVC.view.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}
