//
//  AppStoreItem.swift
//  AppleSearch
//
//  Created by Heli Bavishi on 11/19/20.
//

import Foundation

struct AppStoreItem {
    let title: String
    let subTitle: String
    let imageURL: String?
    
    enum itemType: String {
        case app = "software"
        case song = "musicTrack"
    }
}

extension AppStoreItem {
    
    init?(itemType: AppStoreItem.itemType, dict: [String : Any]) {
        
        if itemType == .app {
            guard let title = dict["trackName"] as? String,
                  let subtitle = dict["description"] as? String
            else { return nil }
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subTitle = subtitle
            self.imageURL = imageURL
        }
        else if itemType == .song {
            guard let title = dict["artistName"] as? String,
                  let subTitle = dict["trackName"] as? String
            else { return nil }
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subTitle = subTitle
            self.imageURL = imageURL
        }
        else {
            print("No initilizer for specified item")
            return nil
        }
    }
}
