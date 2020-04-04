//
//  VirtualObject.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-12.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

public enum VirtualObjectType: Int {
    case painting, electronic
}

struct VirtualObject: Hashable {
    let name: String
//    let node: VirtualObjectNode
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}

struct VirtualObjectCollection: Hashable {
    let title: String
    let type: VirtualObjectType
    let virtualObjects: [VirtualObject]
    
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public let virtualObjectsFetcher = [
    "models.scnassets/Painting/painting.scn", "art.scnassets/ledtv.scn"
]


public class VirtualObjectNode: SCNReferenceNode {
    let paintedImage: UIImage
    
    init?(using image: UIImage, url: URL) {
        self.paintedImage = image
        super.init(url: url)
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented and disabled")
    }
}

extension VirtualObjectNode {
    /// Returns a `VirtualObject` if one exists as an ancestor to the provided node.
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObjectNode? {
        if let virtualObjectRoot = node as? VirtualObjectNode {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a `VirtualObject`.
        return existingObjectContainingNode(parent)
    }
}
