//
//  ItemTableViewCell.swift
//  AppleSearch
//
//  Created by Heli Bavishi on 11/19/20.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //MARK: - Properties
    
    var item: AppStoreItem? {
     didSet {
        //TO DO: Do some stuff with the views
        updateViews()
     }
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        guard let item = item else { return }
        titleLabel.text = item.title
        subtitleLabel.text = item.subTitle
        itemImageView.image = nil
        
        AppStoreItemController.fetchImageFor(item: item) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.itemImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
