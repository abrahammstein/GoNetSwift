//
//  MovieCell.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

class MovieCell: UITableViewCell {
    static let reuseID = "MovieCell"
    let movieImageView = GoNetImageView(frame: .zero)
    let movieNameLabel   = GoNetTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie: MovieElement) {
        movieImageView.downloadImage(fromURL: movie.image.medium)
        movieNameLabel.text = movie.name
    }
    
    // Configure the NSLayoutConstraint
    private func configure() {
        addSubview(movieImageView)
        addSubview(movieNameLabel)
        let topBottomPadding: CGFloat = 7
        let leadingTrailingPAdding: CGFloat = 16
        let widthHeight: CGFloat = 60
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topBottomPadding),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingPAdding),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingPAdding),
            movieImageView.heightAnchor.constraint(equalToConstant: widthHeight),
            movieImageView.widthAnchor.constraint(equalToConstant: widthHeight),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: topBottomPadding),
            
            movieNameLabel.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 20),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: leadingTrailingPAdding)
        ])
    }
}

