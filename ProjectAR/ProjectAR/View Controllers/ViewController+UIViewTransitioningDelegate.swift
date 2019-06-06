//
//  ViewController+UIViewTransitioningDelegate.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-06-06.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteraction.hasStarted ? dismissInteraction : nil
    }
}
