//
//  PersistentManager.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/15/22.
//

import Foundation

enum PersistenceActionType {
    case add
    case delete
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let history = "history"
    }
    
    static func isMovieAlreadyFavorited(movie: MovieElement, completed: @escaping (GoNetError?) -> Void) {
        retrieveFavoriteMovies { result in
            switch result {
            case .success(let movies):
                guard !movies.contains(movie) else {
                    completed(.alreadyInFavorites)
                    return
                }
                completed(nil)
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func updateWith(favoriteMovie: MovieElement, actionType: PersistenceActionType,
                           completed: @escaping (GoNetError?) -> Void) {
        retrieveFavoriteMovies { result in
            switch result {
            case .success(var movies):
                
                switch actionType {
                case .add:
                    guard !movies.contains(favoriteMovie) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    movies.append(favoriteMovie)
                case .delete:
                    movies.removeAll{$0 == favoriteMovie}
                    
                }
                
                completed(save(favorites: movies))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavoriteMovies(completed: @escaping (Result<[MovieElement], GoNetError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.history) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([MovieElement].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToSaveToFavorites))
        }
    }
    
    
    static func save(favorites: [MovieElement]) -> GoNetError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.history)
            return nil
        } catch {
            return .unableToSaveToFavorites
        }
    }
}

