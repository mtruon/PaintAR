//
//  ViewController.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-02-04.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set up scene content
        setupCamera()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
        
//        // Create a new scene
//        let scene = SCNScene()
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    // MARK: Plus button actions
    // On touch, create an oil painting at that location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        // If touches.count == 2, then user is trying to rotate object
        guard touches.count == 1 else {
            return
        }
        
        guard let touch = touches.first?.location(in: sceneView) else {
            return
        }

        guard let hitResult = sceneView.hitTest(touch, types: .featurePoint).first else {
                return
        }
        
        let position = SCNVector3Make(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z)
        
        let newScene = SCNScene(named: "art.scnassets/oilPainting.scn")!
        let oilPaintingNode = newScene.rootNode.childNode(withName: "oilPainting", recursively: true)
        
        oilPaintingNode?.scale = .init(0.1, 0.1, 0.1)
        oilPaintingNode?.position = position
        sceneView.scene.rootNode.addChildNode(oilPaintingNode!)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        
        // remove all objects
        sceneView.scene.rootNode.enumerateChildNodes { (node,_) in
            node.removeFromParentNode()
        }
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
