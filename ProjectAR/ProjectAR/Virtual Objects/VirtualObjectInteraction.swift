//
//  VirtualObjectInteraction.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-13.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

class VirtualObjectInteraction {
    let sceneView: ARSCNView
    
    /// Most recently interacted virtual object
    var selectedObject: VirtualObject?
    var isSelected = false
    
    var planeAnchor: ARPlaneAnchor?
    
    /// The tracked screen position used to update the `trackedObject`'s position in `updateObjectToCurrentTrackingPosition()`.
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPan))
        sceneView.addGestureRecognizer(panGesture)
        
    }
    
    func selectObject(_ object: VirtualObject) {
        selectedObject = object
        isSelected = true
    }
    
    func releaseSelectedObject() {
        guard self.selectedObject != nil else { return }
        self.selectedObject = nil
        self.isSelected = false
    }
    
    func placeObject(at point: CGPoint, using result: ARHitTestResult) {
        guard selectedObject != nil, let planeAnchor = result.anchor as? ARPlaneAnchor else { return }
        
        // Attaching the node (Virtual Object) to the 3D Point on the Plane (Wall)
        let planePosition = result.worldTransform.columns.3
        selectedObject!.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)
        sceneView.scene.rootNode.addChildNode(selectedObject!)
        
        // Retrieve the orientation of the plane relative to the world
        let anchoredNode = sceneView.node(for: planeAnchor)
        let anchoredNodeOrientation = anchoredNode!.worldOrientation
        
        // Rotate the orientation of the selected object to match orientation of the vertical plane
        selectedObject!.eulerAngles.y = .pi * anchoredNodeOrientation.y
    }
    
    // MARK: - Gesture Actions
    
    /* didPan function handles pan gesture movement of a selected virtual object and utilizes
     some code from Apple's ARKitInteraction code -- Copyright © 2018 Apple Inc. */
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        guard let object = selectedObject else { return }
        
        /* Retrieves the first infinite (ignores size) plane found under the gesture's location */
        let infinitePlaneResults = sceneView.hitTest(gesture.location(in: sceneView), types: .existingPlane)
        var firstResult: ARHitTestResult?
        for result in infinitePlaneResults {
            if (result.anchor as? ARPlaneAnchor) != nil {
                firstResult = result
                break
            }
        }
        guard firstResult != nil else { return }
        
        // The position and orientation of the camera (user) in the world coordinate space
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else { return }
        let cameraWorldPosition = float3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        // Hit test result's position and orientation relative to the world coordinate space
        let worldTransformTranslation = float3((firstResult?.worldTransform.columns.3.x)!,
                                               (firstResult?.worldTransform.columns.3.y)!,
                                               (firstResult?.worldTransform.columns.3.z)!)
        var positionOffsetFromCamera = worldTransformTranslation
            - cameraWorldPosition
        
        // Limit the distance of the object from the camera to a maximum of 10 meters.
        if simd_length(positionOffsetFromCamera) > 10 {
            positionOffsetFromCamera = simd_normalize(positionOffsetFromCamera)
            positionOffsetFromCamera *= 10
        }
        // Applies a translation (movement) to the virtual object
        object.simdPosition = cameraWorldPosition + positionOffsetFromCamera
    }
}
