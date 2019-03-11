//
//  ViewController+ARSCNViewDelegate.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-02.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
    // MARK: ARSCNViewDelegate
    private func createWall(for planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        
        // Create an object based on the size of the plane detected
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                height: CGFloat(planeAnchor.extent.z))
        
        node.geometry = geometry
        node.opacity = 0.8
        let changeColorLow = SCNAction.customAction(duration: 3) { (node, elapsedTime) -> () in
            let percentage = (elapsedTime / 3) * 0.5
//            node.opacity = 0.8 - percentage
            let color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8 - percentage)
            node.geometry!.firstMaterial!.diffuse.contents = color
        }
        let changeColorHigh = SCNAction.customAction(duration: 3) { (node, elapsedTime) -> () in
            let percentage = (elapsedTime / 3) * 0.5
//            node.opacity = 0.3 + percentage
            let color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3 + percentage)
            node.geometry!.firstMaterial!.diffuse.contents = color
        }
        let changeColor = SCNAction.repeatForever(SCNAction.sequence([changeColorLow, changeColorHigh]))
        node.runAction(changeColor)
        
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 1
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Ensures that we received a vertical plane
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else {
            return
        }
        
        let wall = createWall(for: planeAnchor)
        node.addChildNode(wall)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            planeAnchor.alignment == .vertical else { return }
        
        /* Enlarged anchor detection
         We proceed to update the attached node's (Wall) position and size */
        for node in node.childNodes {
            node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            if let plane = node.geometry as? SCNPlane {
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
            }
            
        }
    }
    
}
