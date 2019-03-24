//
//  ViewController+Actions.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-13.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import Foundation
import ARKit

extension ViewController {
    
    private func changeResetButtonOpacity() {
        
    }
    
    func restartScene() {
        isRestartAvailable = false
        
        // Animate restart button to a depressed state
        
        virtualObjectLoader.removeAllVirtualObject()
        virtualObjectInteraction.selectedObject = nil
        
        // TODO: Restart UI when implemented
        
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
