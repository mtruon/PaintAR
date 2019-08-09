//
//  ObjectSelectionViewController.swift
//  ProjectAR
//
//  Created by MICHAEL on 2019-07-30.
//  Copyright © 2019 Michael Truong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ObjectCell"

class ObjectSelectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    var objectTypes = [String : [String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ObjectViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        loadDictionary()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return objectTypes.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return section == 0 ? objectTypes["Oil Painting"]!.count : objectTypes["Electronics"]!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ObjectViewCell else {
            preconditionFailure("Failed to load collection view cell")
        }
    
        // Configure the cell
        switch indexPath.section {
        case 0:
            cell.nameLabel.text = objectTypes["Oil Painting"]![indexPath.row]
        case 1:
            cell.nameLabel.text = objectTypes["Electronics"]![indexPath.row]
        default:
            break
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ObjectHeaderView.self)", for: indexPath) as? ObjectHeaderView else {
            preconditionFailure("Invalid view of element")
        }
        
        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = "Oil Paintings"
        case 1:
            headerView.titleLabel.text = "Electronics"
        default:
            break
        }
        return headerView
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let virtualObjectCell = virtualObject(rawValue: indexPath.row)!
        
        
        return true
        
//        let virtualObjectCell = virtualObject(rawValue: indexPath.row)!
//        selectedVirtualObject = virtualObjectsFetcher[indexPath.row]
//
//        switch virtualObjectCell {
//        case .oilPainting:
//            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageSelectionTableViewController") as? ImageSelectionTableViewController {
//                if let navigationController = navigationController {
//                    navigationController.pushViewController(viewController, animated: true)
//                }
//            }
//
//        default:
//            dismiss(animated: true, completion: nil)
//        }
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: - Helper
    
    func loadDictionary() {
        objectTypes["Oil Painting"] = ["OIL 1", "OIL 2", "OIL 3"]
        objectTypes["Electronics"] = ["LED TV"]
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ObjectSelectionViewController: UICollectionViewDelegateFlowLayout {
    /* TODO: Implement a horizontal scrolling view per section
     */
    
    /// TODO: Size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    /// TODO: Section Insets
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }
    
    /// TODO: Row/Col spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
}
