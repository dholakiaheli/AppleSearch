//
//  UIViewControllerExtensions.swift
//  AppleSearch
//
//  Created by Cameron Stuart on 11/19/20.
//

import UIKit

// Create a snippet.
extension UIViewController {
    
    func presentErrorToUser(localizedError: LocalizedError) {
        
        // Alert from error.
        let alertController = UIAlertController(title: "ERROR", message: localizedError.errorDescription, preferredStyle: .actionSheet)
        
        // Dismiss action.
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        
        // Present alert.
        present(alertController, animated: true)
    }
}
