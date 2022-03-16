//
//  GoNetMovieDetailVC.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/16/22.
//

import UIKit

class GoNetMovieDetailVC: UIViewController {

    var movie: MovieElement!
    let movieImageView = GoNetImageView(frame: .zero)
    let summaryLabel   = GoNetBodyLabel(textAlignment: .center)
    let imdbLabel      = GoNetBodyLabel(textAlignment: .center)
    let scrollView     = UIScrollView()
    let scrollViewContainer = UIStackView()
    var navButton: UIBarButtonItem!
    
    init(movie: MovieElement) {
        super.init(nibName: nil, bundle: nil)
        self.movie  = movie
        title       = movie.name
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationBar()
        configure()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString: "234FHF")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .white
        
        PersistenceManager.isMovieAlreadyFavorited(movie: self.movie) { status in
            if status == .alreadyInFavorites {
                self.createUnfavoriteBarButtonItem()
            }
            else {
                self.createFavoriteBarButtonItem()
            }
        }
    }
    
    @objc private func handleUnfavorite() {
        self.handleMoveToTrash(movie: self.movie)
        self.createFavoriteBarButtonItem()
    }
    
    @objc private func handleFavorite() {
        self.handleMarkAsFavourite(movie: self.movie)
        self.createUnfavoriteBarButtonItem()
    }
    
    private func createFavoriteBarButtonItem() {
        self.navButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.handleFavorite))
        navigationItem.rightBarButtonItems = [navButton]
    }
    
    private func createUnfavoriteBarButtonItem() {
        self.navButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(self.handleUnfavorite))
        navigationItem.rightBarButtonItems = [navButton]
    }
    
    @objc private func openIMDB() {
        if let imdb = movie.externals.imdb {
            if let url = URL(string: "https://www.imdb.com/title/\(imdb)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func configure() {
        movieImageView.downloadImage(fromURL: movie.image.original)
        
        let attributedString = try? NSAttributedString(data: movie.summary.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        summaryLabel.attributedText = attributedString
        summaryLabel.numberOfLines = 0
        
        if let imdb = movie.externals.imdb {
            let url = "https://www.imdb.com/title/\(imdb)"
            let attributedIMDB = NSMutableAttributedString(string: url, attributes:[NSAttributedString.Key.link: URL(string: url)!])

            imdbLabel.attributedText = attributedIMDB
            imdbLabel.isUserInteractionEnabled = true
            let tapURLGesture = UITapGestureRecognizer()
            tapURLGesture.addTarget(self, action:#selector(openIMDB))
            imdbLabel.addGestureRecognizer(tapURLGesture)
        }
        
        scrollViewContainer.axis = .vertical
        scrollViewContainer.spacing = 10
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollViewContainer)
        self.scrollViewContainer.addArrangedSubview(movieImageView)
        self.scrollViewContainer.addArrangedSubview(summaryLabel)
        self.scrollViewContainer.addArrangedSubview(imdbLabel)
        let padding: CGFloat = 8
        let leadingTrailingPadding: CGFloat = 20
        let height: CGFloat = 200
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20),
            movieImageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: leadingTrailingPadding),
            movieImageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -leadingTrailingPadding),
            movieImageView.heightAnchor.constraint(equalToConstant: height),

            summaryLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: padding),
            summaryLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -padding),
            summaryLabel.heightAnchor.constraint(equalToConstant: 100),

            imdbLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            imdbLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: padding),
            imdbLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -padding),
            imdbLabel.heightAnchor.constraint(equalToConstant: 100),
            imdbLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant:-20)
        ])
    }

}
