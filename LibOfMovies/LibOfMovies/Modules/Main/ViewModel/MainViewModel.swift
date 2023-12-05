//
//  MainViewModel.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import LibOfMoviesNetwork
import LibOfMoviesPersistence
 
// MARK: - Protocol Definition

protocol MainViewModelProtocol {
    var selectedIndex: ((Int) -> Void)? { get set }
    var selectedItem: ((Movie) -> Void)? { get set }
    var refreshCollection: (() -> Void)? { get set }
    
    @MainActor var movies: [Movie] { get }
    var favouriteMovies: [Movie] { get }
    
    @MainActor func toggleFavourites(movie: Movie)
}

// MARK: - Class Definition

class MainViewModel: MainViewModelProtocol {
    // MARK: - Public Callbacks
    
    var selectedIndex: ((Int) -> Void)?
    var selectedItem: ((Movie) -> Void)?
    var refreshCollection: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var movieStrategy: MovieStrategy
    
    // MARK: - Public Properties
    
    public var movies: [Movie] = [] {
        didSet {
            refreshCollection?()
        }
    }
    public var favouriteMovies: [Movie] { movieStrategy.favouriteMovies }
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol, favouritesCaretaker: FavouritesCaretakerProtocol) {
        self.movieStrategy = BaseMovieStrategy(networkManager: networkManager, favouritesCaretaker: favouritesCaretaker)
        bindArrayOfMoviesUpdates()
        setupCollectionData()
    }
    
    // MARK: - Private Methods
    
    private func bindArrayOfMoviesUpdates() {
        movieStrategy.arrayOfMoviesHasBeenUpdated = { [unowned self] in
            selectedIndex?(0)
        }
    }
    
    private func setupCollectionData() {
        selectedIndex = { [unowned self] selectionIndex in
            Task { @MainActor in
                movies = selectionIndex == 0 ? movieStrategy.movies : favouriteMovies
            }
        }
    }
    
    // MARK: - Public Methods
    
    @MainActor
    public func toggleFavourites(movie: Movie) {
        movieStrategy.toggleFavourites(movie: movie)
    }
}
