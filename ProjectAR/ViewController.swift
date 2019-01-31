//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Kushal Pandya on 2019-01-28.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self

        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
    }
}

extension ViewController: ARSKViewDelegate {
    
//    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
//
//    }
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}

