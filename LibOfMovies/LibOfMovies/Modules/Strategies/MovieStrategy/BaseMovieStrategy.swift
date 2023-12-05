//
//  BaseMovieStrategy.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import LibOfMoviesNetwork
import LibOfMoviesPersistence

// MARK: - Class Definition

class BaseMovieStrategy: MovieStrategy {
    // MARK: - Private Callbacks
    
    public var arrayOfMoviesHasBeenUpdated: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let networkManager: NetworkManagerProtocol
    private let favouritesCaretaker: FavouritesCaretakerProtocol
    
    // MARK: - Public Properties
    
    @MainActor public var thrownError: Error? = nil
    @MainActor public var movies: [Movie] = [] {
        didSet {
            arrayOfMoviesHasBeenUpdated?()
        }
    }
    
    public var favouriteMovies: [Movie] {
        favouritesCaretaker.favouriteMovies.map { $0.toModel }
    }
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol, favouritesCaretaker: FavouritesCaretakerProtocol) {
        self.networkManager = networkManager
        self.favouritesCaretaker = favouritesCaretaker
        fetchNowPlaying()
    }
    
    // MARK: - Private Methods
    
    private func fetchNowPlaying() {
        Task { @MainActor in
            do {
                movies = try await networkManager.fetchNowPlaying().map { $0.toModel }
            } catch NetworkError.wrongURL {
                thrownError = NetworkError.wrongURL
            } catch NetworkError.couldntFetchData {
                thrownError = NetworkError.couldntFetchData
            }
        }
    }
    
    // MARK: - Public Methods
    
    @MainActor
    public func toggleFavourites(movie: Movie) {
        let shouldBeRemoved = favouriteMovies.contains(where: { movie.id == $0.id })
        if shouldBeRemoved {
            favouritesCaretaker.deleteMovieFromFavourites(movie: movie.toPOCO)
        } else {
            favouritesCaretaker.addFavouriteMovie(movie: movie.toPOCO)
        }
    }
}
