//
//  ObjectSelectionViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2020-04-02.
//  Copyright © 2020 Michael Truong. All rights reserved.
//

import UIKit

class ObjectSelectionViewController: UIViewController {
    // TODO: Remove this global variable -- Need Global to store selected virtual object
    public var selectedVirtualObject: String = virtualObjectsFetcher[0]    
    
    var objectSelectionCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<VirtualObjectCollection, VirtualObject>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<VirtualObjectCollection, VirtualObject>! = nil

    /* Dummy node which are simply identifiers that map to
     a constant fetcher -- see paintingimages.swift and virtualobject.swift
    
     Need to implement a feature which loads objects
     */
    private var virtualObjectCollections: [VirtualObjectCollection] = {
        return [
            VirtualObjectCollection(
                title: "Paintings",
                type: .painting,
                virtualObjects: [VirtualObject(name: "Cleopatra"), VirtualObject(name: "Self Portrait"), VirtualObject(name: "Cabeza")]),
            VirtualObjectCollection(
                title: "Electronics",
                type: .electronic,
                virtualObjects: [VirtualObject(name: "LED Tv")])
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Virtual Objects"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension ObjectSelectionViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (sectionIndex: Int,layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group -- if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            // Supplementary Title Header Item
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: "title-element-kind",
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func configureHierarchy() {
        objectSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        objectSelectionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        objectSelectionCollectionView.backgroundColor = .systemBackground
        objectSelectionCollectionView.delegate = self
        view.addSubview(objectSelectionCollectionView)
        NSLayoutConstraint.activate([
            objectSelectionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            objectSelectionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            objectSelectionCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            objectSelectionCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        // Registering cells..
        objectSelectionCollectionView.register(VirtualObjectCell.self, forCellWithReuseIdentifier: VirtualObjectCell.reuseIdentifier)
        objectSelectionCollectionView.register(TitleSupplementaryView.self,
                                               forSupplementaryViewOfKind: "title-element-kind",
                                               withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<VirtualObjectCollection,VirtualObject> (collectionView: objectSelectionCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, virtualObject: VirtualObject) -> UICollectionViewCell? in
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VirtualObjectCell.reuseIdentifier,
                for: indexPath) as? VirtualObjectCell
                else {
                    fatalError("Cannot create new cell")
                }
            // Configure cell
            cell.titleLabel.text = virtualObject.name
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }

            // Get a supplementary view of the desired kind.
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView {

                // Populate the view with our section's description.
                let objectCategory = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.label.text = objectCategory.title

                // Return the view.
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        // Applies the snapshot to the diffable datasource
        currentSnapshot = NSDiffableDataSourceSnapshot<VirtualObjectCollection, VirtualObject>()
        virtualObjectCollections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems((collection.virtualObjects))
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension ObjectSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPaintingImage =  paintingImagesFetcher[indexPath.row]
        print(virtualObjectCollections[indexPath.section].virtualObjects[indexPath.row].name)
        dismiss(animated: true, completion: nil)
    }
}
