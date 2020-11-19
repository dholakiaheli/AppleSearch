//
//  AppleStoreItemTableViewController.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import UIKit

class AppleStoreItemTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var itemSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    var appleStoreItems: [AppleStoreItem] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSearchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleStoreItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppleStoreItemCell", for: indexPath) as! ItemTableViewCell
        
        let appleStoreItem = appleStoreItems[indexPath.row]
        cell.item = appleStoreItem
        
        return cell
    }
}

extension AppleStoreItemTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = itemSearchBar.text, !searchText.isEmpty else { return }
        
        let itemType: AppleStoreItem.ItemType = (itemSegmentedControl.selectedSegmentIndex == 0) ? .song : .app
        
        AppleStoreItemController.getItems(type: itemType, searchText: searchText) { (items) in
            self.appleStoreItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.itemSearchBar.text = ""
            }
        }
    }
}
