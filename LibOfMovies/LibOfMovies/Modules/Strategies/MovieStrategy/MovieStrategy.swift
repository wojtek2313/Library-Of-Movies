//
//  MovieStrategy.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation

// MARK: - Protocol Definition

protocol MovieStrategy {
    var arrayOfMoviesHasBeenUpdated: (() -> Void)? { get set }
    
    @MainActor var thrownError: Error? { get }
    @MainActor var movies: [Movie] { get }
    var favouriteMovies: [Movie] { get }
    
    @MainActor func toggleFavourites(movie: Movie)
    func updateNowPlaying()
}
