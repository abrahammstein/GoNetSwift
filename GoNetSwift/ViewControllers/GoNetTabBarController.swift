//
//  GoNetTabBarController.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

class GoNetTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers                 = [createSearchNC(), createFavoritesNC()]
    }
    
    // This method is going to return a UINavigationController for our Searches
    private func createSearchNC() -> UINavigationController {
        let movieListVC        = GoNetMovieListVC()
        movieListVC.title      = "TV Shows"
        movieListVC.tabBarItem = UITabBarItem(title: "Shows", image: UIImage(systemName: "folder.fill"), tag: 0)
        
        return UINavigationController(rootViewController: movieListVC)
    }
    
    // This method is going to return a UINavigationController for our SearchHistory
    private func createFavoritesNC() -> UINavigationController {
        let favoritesListVC         = GoNetFavoriteListVC()
        favoritesListVC.title       = "TV Shows"
        favoritesListVC.tabBarItem  = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }

}
