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
    
    private var page: Int = 1
    private var isDownloadingData = false
    
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
        isDownloadingData = true
        Task { @MainActor in
            do {
                let results = try await networkManager.fetchNowPlaying(atPage: page).map { $0.toModel }
                movies.append(contentsOf: results)
                isDownloadingData = false
            } catch NetworkError.wrongURL {
                thrownError = NetworkError.wrongURL
                isDownloadingData = false
            } catch NetworkError.couldntFetchData {
                thrownError = NetworkError.couldntFetchData
                isDownloadingData = false
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
    
    public func updateNowPlaying() {
        guard !isDownloadingData else { return }
        page += 1
        fetchNowPlaying()
    }
}
