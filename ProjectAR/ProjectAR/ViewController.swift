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
    
    // MARK: Plus button action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If touches.count == 2, then user is trying to rotate object
        guard touches.count == 1 else {
            return
        }
        
        guard let touchLocation = touches.first?.location(in: sceneView) else {
            return
        }
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
        if let result = hitTestResult.first {
            
            /* TODO: Move this into different code for object selection */
            
            let modelURL = URL(fileReferenceLiteralResourceName: selectedVirtualObject)
            guard let paintedImage = UIImage(named: selectedPaintingImage) else {
                return
            }
            guard let frame = VirtualObject(using: paintedImage, url: modelURL) else { return }
            virtualObjectLoader.loadVirtualObject(frame)
            virtualObjectInteraction.selectedObject = frame
            virtualObjectInteraction.placeObject(at: touchLocation, using: result)
            
            
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
