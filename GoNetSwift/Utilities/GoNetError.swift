//
//  GoNetError.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import Foundation

enum GoNetError: String, Error {
    case invalidURL         = "That URL is invalid. Please double check it."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToSaveToFavorites  = "There was an error saving this movie to the favorites. Please try again."
    case alreadyInFavorites        = "This movie was already added to your favorites."
}
