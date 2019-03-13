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
        let anchoredNode = sceneView.node(for: planeAnchor)
        let anchoredNodeOrientation = anchoredNode!.worldOrientation
        selectedObject!.eulerAngles.y = .pi * anchoredNodeOrientation.y
        
    }
    
    //    private func createPainting(with image: UIImage, using result: ARHitTestResult) {
    //
    //        // Retrieve frame scene
    //        let frameScene = SCNScene(named: "models.scnassets/Painting/painting.scn")
    //        guard let frameNode = frameScene?.rootNode.childNode(withName: "Painting", recursively: false) else {
    //            return
    //        }
    //
    //        // Retrieve painting node from frame scene hierarchy
    //        guard let paintingNode = frameScene?.rootNode.childNode(withName: "PaintedImage", recursively: true) else {
    //            return
    //        }
    //        paintingNode.geometry?.firstMaterial?.diffuse.contents = image
    //
    //        // Place the frame at the user's touch location
    //        let planePosition = result.worldTransform.columns.3
    //        frameNode.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)
    //
    //        // Add frame node to the scene
    //
    //        sceneView.scene.rootNode.addChildNode(frameNode)
    //    }
}
