//
//  ViewController.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-02-04.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    // Loads virtual objects
    let virtualObjectLoader = VirtualObjectLoader()
    
    var isRestartAvailable = true
    
    /// The view controller that displays the onboarding and user directive messages
    lazy var messageViewController: MessageViewController = {
        return children.lazy.compactMap({ $0 as? MessageViewController }).first!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set up scene content
        setupCamera()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
        
        messageViewController.scheduleMessage("Hello 👋!", forDuration: 1.5)
        messageViewController.scheduleMessage("Begin by pointing at a wall", forDuration: 1.5)
        
        for i in 0...2 {
            messageViewController.scheduleMessage("\(i)", forDuration: 0.8)
        }
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
    
    // - MARK: UI Actions
    /* Handles interaction with the scene view if no virtual object is selected. The
     use should be able to select a virtual object or place an object. */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard virtualObjectInteraction.selectedObject == nil else { return }
        
        // If touches.count is >= 2 then the user is likely trying to rotate the object.
        guard touches.count == 1 else { return }
        
        guard let touchLocation = touches.first?.location(in: sceneView) else { return }
        
        // Testoimg
        messageViewController.scheduleMessageImmediately("TAP", forDuration: 0.5)
        
        let scnHitTestResult = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.boundingBoxOnly: true])
        for result in scnHitTestResult {
            if let object = VirtualObject.existingObjectContainingNode(result.node) {
                // A virtual object has been found do not continue
                print("Virtual Object hit @ \(object.referenceURL)")
                messageViewController.scheduleMessageImmediately("Touched an object", forDuration: 1.0)
                virtualObjectInteraction.selectObject(object)
                return
            }
        }
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
        if let result = hitTestResult.first {
            
            let modelURL = URL(fileReferenceLiteralResourceName: selectedVirtualObject)
            guard let paintedImage = UIImage(named: selectedPaintingImage) else {
                return
            }
            guard let painting = VirtualObject(using: paintedImage, url: modelURL) else { return }
            virtualObjectLoader.loadVirtualObject(painting)
            virtualObjectInteraction.selectObject(painting)
            virtualObjectInteraction.placeObject(at: touchLocation, using: result)
            virtualObjectInteraction.releaseSelectedObject()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let restartMessage = "All virtual objects will be removed and the configuration will be recreated."
        let alert = UIAlertController(title: "Restart Scene", message: restartMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Destructive action"), style: .destructive, handler: { _ in
            NSLog("The Restart Scene \"OK\" destructive action alert occured.")
            self.restartScene()
            
            // Spring rewind animation for user feedback
            let rewindAnimation = CASpringAnimation(keyPath: "transform.rotation")
            rewindAnimation.fromValue = 0
            rewindAnimation.toValue = Double.pi * 2
            rewindAnimation.duration = 1.2
            self.resetButton.layer.add(rewindAnimation, forKey: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Escape action"), style: .cancel, handler: { _ in
            NSLog("The Restart Scene \"Cancel\" escape alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ARSCNView {
    /// Hit tests against the `sceneView` to find an object at the provided point.
//    func virtualObject(at point: CGPoint) -> VirtualObject? {
//        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
//        let hitTestResults = hitTest(point, options: hitTestOptions)
//
//        return hitTestResults.lazy.compactMap { result in
//            return VirtualObject.existingObjectContainingNode(result.node)
//            }.first
//    }
}
