//
//  ViewController+Actions.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-13.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import Foundation
import ARKit

extension ViewController {
    
    func restartUI() {
        
//        messageViewController.
    }
    
    func restartScene() {
        isRestartAvailable = false
        
        // Virtual Object Interaction
        virtualObjectLoader.removeAllVirtualObject()
        virtualObjectInteraction.releaseSelectedObject()
        
        // TODO: Restart UI when implemented
        messageViewController.clearScheduledMessage()
        
        // Recreate session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Disable restart to provide cushioning and prohibit destructive behaviour
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
}
