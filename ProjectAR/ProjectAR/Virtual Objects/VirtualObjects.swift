//
//  VirtualObjects.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-03-21.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import Foundation

public enum virtualObject: Int {
    case oilPainting
    case ledTv
}

public let virtualObjectsFetcher = [
    "models.scnassets/Painting/painting.scn",
    "art.scnassets/ledtv.scn"
]
