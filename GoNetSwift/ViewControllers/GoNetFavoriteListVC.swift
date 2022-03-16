//
//  GoNetFavoriteListVC.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/16/22.
//

import UIKit

class GoNetFavoriteListVC: UIViewController {

    let tableView = UITableView()
    var favoriteMovies: [MovieElement]   = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteMovies()
        configureNavigationBar()
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "TV Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString: "661FFF")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 74
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
    }
    
    func getFavoriteMovies() {
        PersistenceManager.retrieveFavoriteMovies { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
                
            case .failure(let error):
                self.presentGoNetAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    private func updateUI(with movies: [MovieElement]) {
        if movies.isEmpty {
            self.presentGoNetAlertOnMainThread(title: "Oops no favorites", message: "No Favorite Movies?\nTry adding some by swiping 😁.", buttonTitle: "Ok")
        } else  {
            self.favoriteMovies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension GoNetFavoriteListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseID) as! MovieCell
        let favoriteMovie = favoriteMovies[indexPath.row]
        cell.set(movie: favoriteMovie)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie      = favoriteMovies[indexPath.row]
        let detailVC   = GoNetMovieDetailVC(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = self.favoriteMovies[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(movie: movie)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
    
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
