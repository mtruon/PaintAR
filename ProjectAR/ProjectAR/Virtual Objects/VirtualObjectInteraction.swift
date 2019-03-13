//
//  VirtualObjectInteraction.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-13.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class VirtualObjectInteraction {
    let sceneView: ARSCNView
    
    // Most recently interacted virtual object
    var selectedObject: VirtualObject?
    var isSelected = false
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func placeObject(at point: CGPoint, using result: ARHitTestResult) {
        guard selectedObject != nil,
            let planeAnchor = result.anchor as? ARPlaneAnchor else { return }
        isSelected = true
        let planePosition = result.worldTransform.columns.3
        selectedObject!.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)
        sceneView.scene.rootNode.addChildNode(selectedObject!)
        
        // Retrieve the orientation of the plane relative to the world
        let anchoredNode = sceneView.node(for: planeAnchor)
        let anchoredNodeOrientation = anchoredNode!.worldOrientation
        
        // Rotate the orientation of the selected object to match orientation of the vertical plane
        selectedObject!.eulerAngles.y = .pi * anchoredNodeOrientation.y
    }
}
