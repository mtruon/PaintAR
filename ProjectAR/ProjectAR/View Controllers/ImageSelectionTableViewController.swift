//
//  ImageSelectionTableViewController.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-03-21.
//  Copyright © 2019 Kushal Pandya. All rights reserved.
//

import UIKit

// Need Global to store selected painting image
public var selectedPaintingImage: String = paintingImagesFetcher[0]

class ImageSelectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paintingImagesFetcher.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let paintingImageCell = paintingImages(rawValue: indexPath.row)
        cell.textLabel?.text = "\(paintingImageCell!)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPaintingImage =  paintingImagesFetcher[indexPath.row]
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
