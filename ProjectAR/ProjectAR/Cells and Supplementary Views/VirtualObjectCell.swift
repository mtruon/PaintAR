//
//  VirtualObjectCell.swift
//  ProjectAR
//
//  Created by MICHAEL on 2020-04-04.
//  Copyright © 2020 Michael Truong. All rights reserved.
//

import UIKit

class VirtualObjectCell: UICollectionViewCell {
    
    static let reuseIdentifier = "virtual-object-reuse-identifier"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VirtualObjectCell {
    func configure() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = CGFloat(21.0)
        contentView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(titleLabel)
    }
}

