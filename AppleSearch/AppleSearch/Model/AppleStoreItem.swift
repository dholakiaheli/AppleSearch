//
//  AppleStoreItem.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import Foundation

struct AppleStoreItem {
    let title: String
    let subtitle: String
    let imageURL: String?
    
    enum ItemType: String {
        case app = "software"
        case song = "musicTrack"
    }
}

extension AppleStoreItem {
    
    init?(itemType: AppleStoreItem.ItemType, dict: [String:Any]) {
        
        if itemType == .app {
            // build an app AppStoreItem
            guard let title = dict["trackName"] as? String,
                let subtitle = dict["description"] as? String else { return nil }
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            
            
        } else if itemType == .song {
            // builf a song AppStoreItem
            guard let title = dict["artistName"] as? String,
                let subtitle = dict["trackName"] as? String else { return nil }
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            
        } else {
            print("No initilization options for other types at this point.")
            return nil
        }
    }
}
