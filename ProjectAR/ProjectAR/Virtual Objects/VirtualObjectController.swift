//
//  VirtualObjectController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2020-04-04.
//  Copyright © 2020 Michael Truong. All rights reserved.
//

import Foundation

class VirtualObjectController {
    private(set) var loadedObjects = [VirtualObjectNode]()
    
    // Loads the virtual object's scene from the reference node
    func loadVirtualObject(_ object: VirtualObjectNode) {
        loadedObjects.append(object)
        object.load()
        
        // Attaches the painted image onto the paintedImage plane
        guard let paintingNode = object.childNode(withName: "PaintedImage", recursively: true) else { return }
        paintingNode.geometry?.firstMaterial?.diffuse.contents = object.paintedImage
    }
    
    func removeVirtualObject(at index: Int) {
        guard loadedObjects.indices.contains(index) else { return }
        loadedObjects[index].removeFromParentNode()
        loadedObjects.remove(at: index)
    }
    
    func removeAllVirtualObject() {
        // Reverse the list of indicies to avoid skipping objects others are removed
        for index in loadedObjects.indices.reversed() {
            removeVirtualObject(at: index)
        }
    }
}
