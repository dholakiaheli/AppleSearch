//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Heli Bavishi on 11/19/20.
//

import UIKit
class AppStoreItemController {
    
    //https://itunes.apple.com/search?term=Converge&entity=musicTrack

    static let baseURL = URL(string: "https://itunes.apple.com/search")
    static let termQueryKey = "term"
    static let entityQueryKey = "entity"
    
    static func fetchItems(type: AppStoreItem.itemType, searchTerm: String, completion: @escaping ((Result<[AppStoreItem], AppStoreItemError>) -> Void)) {
        
        guard let baseURL = baseURL else { return completion(.failure(.couldNotUnwrap))}
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let searchTermQuery = URLQueryItem(name: termQueryKey, value: searchTerm)
        let entityQuery = URLQueryItem(name: entityQueryKey, value: type.rawValue)
        
        components?.queryItems = [searchTermQuery, entityQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.couldNotUnwrap))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n----\n \(error)")
                return completion(.failure(.apiError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let topLevelDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return completion(.failure(.unableToDecode))}
            
            guard let resultsDict = topLevelDict["results"] as? [[String: Any]] else { return completion(.failure(.unableToDecode))}
            
            var fetchItems: [AppStoreItem] = []
            
            for item in resultsDict {
                if let newItem = AppStoreItem(itemType: type, dict: item) {
                    fetchItems.append(newItem)
                }
            }
            return completion(.success(fetchItems))
        }.resume()
    }
    
    static func fetchImageFor(item: AppStoreItem, completion: @escaping ((Result<UIImage,AppStoreItemError>) -> Void)) {
    
        guard let imageURL = item.imageURL, let url = URL(string: imageURL) else { return completion(.failure(.couldNotUnwrap)) }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n----\n \(error)")
                return completion(.failure(.apiError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else { return completion (.failure(.unableToDecode)) }
            
            return completion(.success(image))
        }.resume()
    }
    
} // END of class
