//
//  SelectionModalViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-04-06.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

protocol SelectionModalDelegate: class {
    
}

class SelectionModalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
//    lazy var originalY = containerView.frame.minY
    
    // define a variable to store initial touch position
//    lazy var initialTouchLocation: CGPoint = CGPoint(x: 0,y: originalY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.applyRoundCornerMaskWith(radius: 20, corners: [.topRight, .topLeft])
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPan))
//        containerView.addGestureRecognizer(panGesture)
    }
    
//    @objc func didPan(gesture: UIPanGestureRecognizer) {
//        let touchLocation = gesture.location(in: containerView)
//
//        switch gesture.state {
//        case .began:
//            initialTouchLocation = touchLocation
//            break
//        case .changed:
//            if touchLocation.y - initialTouchLocation.y > originalY {
//                containerView.frame = CGRect(x: 0, y: touchLocation.y - initialTouchLocation.y, width: containerView.frame.size.width, height: containerView.frame.size.height)
//            }
//            break
//        case .ended:
//            if touchLocation.y - initialTouchLocation.y > 100 + originalY {
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.containerView.frame = CGRect(x: 0, y: self.originalY, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
//                })
//            }
//        default:
//            break
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
