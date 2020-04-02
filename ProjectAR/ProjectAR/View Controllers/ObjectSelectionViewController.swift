//
//  ObjectSelectionViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2020-04-02.
//  Copyright © 2020 Michael Truong. All rights reserved.
//

import UIKit

class ObjectSelectionViewController: UIViewController {

    var objectSelectionCollectionView: UICollectionView! = nil
    private lazy var objects: [String: [String]] = {
        return ["Oil Painting": ["Oil 1", "Oil 2", "Oil 3"],
                "Electronics": ["LED TV"]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension ObjectSelectionViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
//        collectionView.register(OutlineItemCell.self, forCellWithReuseIdentifier: OutlineItemCell.reuseIdentifer)
        self.objectSelectionCollectionView = collectionView
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemHeightDimension = NSCollectionLayoutDimension.absolute(100)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ObjectSelectionViewController: UICollectionViewDelegate {
    
}
