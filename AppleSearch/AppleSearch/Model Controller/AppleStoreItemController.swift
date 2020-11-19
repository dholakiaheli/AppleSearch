//
//  AppleStoreItemController.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import UIKit

class AppleStoreItemController {
    
    static func getItems(type: AppleStoreItem.ItemType, searchText: String, completion: @escaping ((Result<[AppleStoreItem], AppleStoreItemError>) -> Void)) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return completion(.failure(.unableToUnwrap))
        }
        
        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        guard let url = components.url else {
            return completion(.failure(.unableToUnwrap))
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from apple. \(error.localizedDescription)")
                return completion(.failure(.apiError(error)))
            }
            
            guard let data = data else {
                print("No data was received from apple.")
                return completion(.failure(.noData))
            }
            
            guard let topLevelJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] else {
                print("Could not convert data into JSON.")
                return completion(.failure(.unableToDecode))
            }
            
            // Here is where we dive deeper.
            guard let appleStoreItemDictionaries = topLevelJSON["results"] as? [[String:Any]] else {
                print("Could not access the dictionaries from the results level.")
                return completion(.failure(.unableToDecode))
            }
            
            var fetchedItems: [AppleStoreItem] = []
            
            for itemDictionary in appleStoreItemDictionaries {
                if let newItem = AppleStoreItem(itemType: type, dict: itemDictionary) {
                    fetchedItems.append(newItem)
                }
            }
            
            completion(.success(fetchedItems))
            
            }.resume()
    }
    
    static func getImageFor(item: AppleStoreItem, completion: @escaping ((Result<UIImage, AppleStoreItemError>) -> Void)) {
        
        guard let imageURLAsString = item.imageURL, let url = URL(string: imageURLAsString) else {
            print("Item did not have an image that could be made into a url.")
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error \(error)")
                return completion(.failure(.apiError(error)))
            }
            
            guard let data = data else {
                print("Could not get data from the image.")
                return completion(.failure(.noData))
            }
            
            guard let image = UIImage(data: data) else {
                print("Unable to convert our image into data.")
                return completion(.failure(.unableToDecode))
            }
            
            completion(.success(image))
            
            }.resume()
    }
}
