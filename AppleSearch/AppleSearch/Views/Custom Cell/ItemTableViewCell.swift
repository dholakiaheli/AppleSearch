//
//  ItemTableViewCell.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    // MARK: - Properties
    var item: AppleStoreItem? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let item = item else { return }
        
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        //This prevents an old image from displaying if the current item has no image, as well as flickering of images if the user were to scroll through the tableView quickly.
        itemImageView.image = nil
        
        AppleStoreItemController.getImageFor(item: item) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.itemImageView.image = image
                }
            } else {
                print("Image was nil")
            }
        }
    }
}
