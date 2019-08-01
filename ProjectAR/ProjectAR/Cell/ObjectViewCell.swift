//
//  ObjectViewCell.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-07-30.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

class ObjectViewCell: UICollectionViewCell {
    
    // MARK: - Components
    let nameLabel = UILabel()
    let bgView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure background items
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 20

        // Background view
        bgView.frame = self.bounds
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.backgroundView = bgView

        // Stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isBaselineRelativeArrangement = true
        stackView.spacing = 21.0
        self.addSubview(stackView)

        // Configures name label
        nameLabel.text = "Object"
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
