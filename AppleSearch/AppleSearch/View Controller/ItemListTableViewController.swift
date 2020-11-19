//
//  ItemListTableViewController.swift
//  AppleSearch
//
//  Created by Heli Bavishi on 11/19/20.
//

import UIKit

class ItemListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var itemSegmentedControl: UISegmentedControl!
    //MARK: - Properties
    
    var appItems: [AppStoreItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSearchBar.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = 150
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appleCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        
        let item = appItems[indexPath.row]
        cell.item = item
        return cell
    }
    
} //END of class

extension ItemListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = itemSearchBar.text, !searchText.isEmpty else { return }
        
        let itemType: AppStoreItem.itemType = (itemSegmentedControl.selectedSegmentIndex == 0) ?.song : .app
        
        AppStoreItemController.fetchItems(type: itemType, searchTerm: searchText) {  (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.appItems = items
                    self.tableView.reloadData()
                    self.itemSearchBar.text = ""
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
