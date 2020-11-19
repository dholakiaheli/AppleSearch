//
//  AppleStoreItemController.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import UIKit

class AppleStoreItemController {
    
    static func getItems(type: AppleStoreItem.ItemType, searchText: String, completion: @escaping (([AppleStoreItem]) -> Void)) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion([])
            return
        }
        
        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        guard let url = components.url else {
            print("Our query items are giving us some trouble.")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from apple. \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data was received from apple.")
                completion([])
                return
            }
            
            guard let topLevelJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] else {
                print("Could not convert data into JSON.")
                completion([])
                return
            }
            
            // Here is where we dive deeper.
            guard let appleStoreItemDictionaries = topLevelJSON["results"] as? [[String:Any]] else {
                print("Could not could dictionaries from the results.")
                completion([])
                return
            }
            
            var allItems: [AppleStoreItem] = []
            
            for itemDictionary in appleStoreItemDictionaries {
                if let newItem = AppleStoreItem(itemType: type, dict: itemDictionary) {
                    allItems.append(newItem)
                }
            }
            
            completion(allItems)
            
            }.resume()
    }
    
    static func getImageFor(item: AppleStoreItem, completion: @escaping ((UIImage?) -> Void)) {
        
        guard let imageURLAsString = item.imageURL,
            let url = URL(string: imageURLAsString) else {
                print("Item did not have an image that could be made into a url.")
                completion(nil)
                return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Could not get data from the image.")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
            }.resume()
    }
}
