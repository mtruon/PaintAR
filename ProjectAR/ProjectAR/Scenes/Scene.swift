//
//  Scene.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-02-04.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import SceneKit
import SpriteKit
import ARKit

class Scene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
        
            // Code to add "model/bird"
            if let hit = sceneView.hitTest(touchLocation, types: .featurePoint).first {
                sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
            }
        }
    }
    
}
