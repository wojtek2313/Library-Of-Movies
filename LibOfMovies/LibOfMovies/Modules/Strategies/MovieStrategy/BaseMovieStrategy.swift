//
//  BaseMovieStrategy.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import LibOfMoviesNetwork

// MARK: - Class Definition

class BaseMovieStrategy: MovieStrategy {
    // MARK: - Private Callbacks
    
    public var arrayOfMoviesHasBeenUpdated: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Public Properties
    
    @MainActor public var thrownError: Error? = nil
    @MainActor public var movies: [Movie] = [] {
        didSet {
            arrayOfMoviesHasBeenUpdated?()
        }
    }
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        
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
}
