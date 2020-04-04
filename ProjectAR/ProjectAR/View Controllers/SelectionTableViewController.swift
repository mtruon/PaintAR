//
//  TODO: To be removed from code base
//  SelectionTableViewController.swift
//  ProjectAR
//
//  Created by Kushal Pandya on 2019-03-21.
//  Copyright © 2019 Kushal Pandya, Michael Truong. All rights reserved.
//

import UIKit

// Need Global to store selected virtual object
public var selectedVirtualObject: String = virtualObjectsFetcher[0]

class SelectionTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return virtualObjectsFetcher.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let virtualObjectCell = VirtualObjectType(rawValue: indexPath.row) {
            switch virtualObjectCell {
            case .painting:
                cell.textLabel?.text = "Oil Painting"
                cell.accessoryType = .disclosureIndicator
            case .electronic:
                cell.textLabel?.text = "LED TV"
            }
        }
        
        // Display checkmark if ledtv is selected
        if selectedVirtualObject != virtualObjectsFetcher[0] && selectedVirtualObject == virtualObjectsFetcher[indexPath.row] {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let virtualObjectCell = VirtualObjectType(rawValue: indexPath.row)!
        selectedVirtualObject = virtualObjectsFetcher[indexPath.row]
        
        switch virtualObjectCell {
        case .painting:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageSelectionTableViewController") as? ImageSelectionTableViewController {
                if let navigationController = navigationController {
                    navigationController.pushViewController(viewController, animated: true)
                }
            }

        default:
            dismiss(animated: true, completion: nil)
        }
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
