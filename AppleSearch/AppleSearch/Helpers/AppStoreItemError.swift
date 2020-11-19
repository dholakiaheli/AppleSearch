//
//  AppStoreItemError.swift
//  AppleSearch
//
//  Created by Heli Bavishi on 11/19/20.
//

import Foundation

enum AppStoreItemError: LocalizedError {
    
    case couldNotUnwrap
    case noData
    case apiError(Error)
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .couldNotUnwrap:
            return "unable to unwrap the given object"
        case .noData:
            return "did not receive any data from the cell"
        case .apiError(let error):
            return "received an error :\(error.localizedDescription)"
        case .unableToDecode:
            return "could not decode the data returned"
        }
    }
}

