//
//  MainViewModel.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import LibOfMoviesNetwork
 
// MARK: - Protocol Definition

protocol MainViewModelProtocol {
    var selectedIndex: ((Int) -> Void)? { get set }
    var selectedItem: ((Movie) -> Void)? { get set }
    var refreshCollection: (() -> Void)? { get set }
    
    @MainActor var movies: [Movie] { get }
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
    
    @MainActor public var movies: [Movie] { movieStrategy.movies }
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol) {
        self.movieStrategy = BaseMovieStrategy(networkManager: networkManager)
        bindArrayOfMoviesUpdates()
    }
    
    private func bindArrayOfMoviesUpdates() {
        movieStrategy.arrayOfMoviesHasBeenUpdated = { [unowned self] in
            refreshCollection?()
        }
    }
}
