//
//  AppleStoreItemError.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import Foundation

enum AppleStoreItemError: LocalizedError {
    case unableToUnwrap
    case invalidURL
    case noData
    case apiError(Error)
    case unableToDecode
    
    var errorDescription: String {
        switch self {
        case .unableToUnwrap:
            return "Unable to unwrap the given object."
        case .invalidURL:
            return "We appear to have an invalid URL."
        case .noData:
            return "We did not receive the expected data."
        case .apiError(let error):
            return "We received an error: \(error.localizedDescription)."
        case .unableToDecode:
            return "We are unable to decode the provided data."
        }
    }
}
