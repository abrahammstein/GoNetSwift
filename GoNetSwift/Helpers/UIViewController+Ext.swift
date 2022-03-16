//
//  UIViewController+Ext.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

extension UIViewController {
    
    func presentGoNetAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GoNetAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func handleMarkAsFavourite(movie: MovieElement) {
        PersistenceManager.updateWith(favoriteMovie: movie, actionType: .add) { [weak self] error in
            guard let self = self else { return }

            guard error != nil else {
                return
            }

            self.presentGoNetAlertOnMainThread(title: "Oops, something went wrong", message: "There was a problem saving this TV Show. Do you want to try again?", buttonTitle: "Retry")
        }
    }

    func handleMoveToTrash(movie: MovieElement) {
        PersistenceManager.updateWith(favoriteMovie: movie, actionType: .delete) { error in
            self.presentGoNetAlertOnMainThread(title: "😎", message: "Movie Removed Succesfully", buttonTitle: "Ok")
            if self.isKind(of: GoNetFavoriteListVC.self) {
                let favoritesVC = self as! GoNetFavoriteListVC
                favoritesVC.getFavoriteMovies()
            }
        }
    }
}
