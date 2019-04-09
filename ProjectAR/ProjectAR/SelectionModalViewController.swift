//
//  SelectionModalViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-04-06.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

protocol SelectionModalDelegate: class {
    
}

class SelectionModalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.applyRoundCornerMaskWith(radius: 20, corners: [.topRight, .topLeft])
    }
}
