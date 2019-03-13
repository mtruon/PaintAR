//
//  VirtualObject.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-03-12.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class VirtualObject: SCNReferenceNode {
    
    let paintedImage: UIImage
    
    init?(using image: UIImage, url: URL) {
        self.paintedImage = image
        super.init(url: url)
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented and disabled")
    }
}
