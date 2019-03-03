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
    private func createWall(on planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        
        // Create an object based on the size of the plane detected
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                height: CGFloat(planeAnchor.extent.z))
        geometry.firstMaterial?.diffuse.contents = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.25)
        node.geometry = geometry
        
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 1
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Ensures that we received a vertical plane
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else {
            return
        }
        
        let wall = createWall(on: planeAnchor)
        node.addChildNode(wall)
        
//        if let image = UIImage(named: "art.scnassets/jmb-self-portrait.jpg") {
//            print("FOUND! A vertical plane has been detected")
//            let wall = createWall(on: planeAnchor)
//            node.addChildNode(wall)
//            print("Here")
//
////            let ship = createPainting(with: image)
////            wall.addChildNode(ship)
//            node.addChildNode(wall)
//        }
        
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
