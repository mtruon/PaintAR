//
//  SelectionModalViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-04-06.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

// Daisy chain
protocol SelectionModalViewControllerDelegate: class {
    func didSelectObject(at indexPath: IndexPath)
}

class SelectionModalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: SelectionModalViewControllerDelegate?
    var dismissInteraction: DismissInteraction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the styling and gesture of selection modal container view controller
        containerView.layer.applyRoundCornerMaskWith(radius: 20, corners: [.topRight, .topLeft])
        addPanGesture(in: containerView)
        
        // TODO: Stub delegates represent a daisy chain to pass information down to the root
        //       view controller -- Flatten hierarchy
        if let childNavController = children[0] as? UINavigationController {
            if let childViewController = childNavController.topViewController as? ObjectSelectionViewController {
                childViewController.delegate = self
            }
        }
    }
    
    func addPanGesture(in view: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SelectionModalViewController.handlePan(sender:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.2
        
        let translation = sender.translation(in: self.view)
        let verticalMovement = translation.y / self.view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let percentCompleted = CGFloat(downwardMovementPercent)
        
        guard let interactor = dismissInteraction else { return }
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
            
        case .changed:
            interactor.shouldFinish = percentCompleted > percentThreshold
            interactor.update(percentCompleted)
            
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
            
        case .ended:
            interactor.hasStarted = false
            if (interactor.shouldFinish) {
                interactor.finish()
            } else {
                interactor.cancel()
            }
            
        default:
            break
        }
        
    }
}

extension SelectionModalViewController: ObjectSelectionCollectionViewControllerDelegate {
    func didSelectObject(at indexPath: IndexPath) {
        delegate?.didSelectObject(at: indexPath)
    }
}
