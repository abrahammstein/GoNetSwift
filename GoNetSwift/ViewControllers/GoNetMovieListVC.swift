//
//  GoNetMovieListVC.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

class GoNetMovieListVC: UIViewController {
    
    let tableView = UITableView()
    var movies: Movie  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMoviesData()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString: "661FFF")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.tabBarController?.tabBar.tintColor = .blue
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "TV Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 74
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
        tableView.isUserInteractionEnabled = true
    }
    
    // This method retrieves a list of movies from a server.
    func getMoviesData() {
        NetworkManager.shared.getMovies() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                self.presentGoNetAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    private func updateUI(with movies: Movie) {
        if movies.isEmpty {
            self.presentGoNetAlertOnMainThread(title: "Oops no movies", message: "No Movies?\nTry checking the URL 😁.", buttonTitle: "Ok")
        } else  {
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}


extension GoNetMovieListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseID) as! MovieCell
        let movie = movies[indexPath.row]
        cell.set(movie: movie)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = self.movies[indexPath.row]
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, completionHandler) in
            if let movie = self?.movies[indexPath.row] {
                self?.handleMarkAsFavourite(movie: movie)
            }
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            if let movie = self?.movies[indexPath.row] {
                self?.handleMoveToTrash(movie: movie)
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        var swipeActions: UISwipeActionsConfiguration!
        
        PersistenceManager.isMovieAlreadyFavorited(movie: movie) { status in
            if status == .alreadyInFavorites {
                swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            }
            else {
                swipeActions = UISwipeActionsConfiguration(actions: [favoriteAction])
            }
        }
        
        
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie      = movies[indexPath.row]
        let detailVC   = GoNetMovieDetailVC(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
