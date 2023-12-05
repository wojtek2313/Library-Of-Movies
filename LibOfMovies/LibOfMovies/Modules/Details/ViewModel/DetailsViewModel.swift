//
//  DetailsViewModel.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 05/12/2023.
//

import Foundation
import LibOfMoviesPersistence

// MARK: - Protocol Definition

protocol DetailsViewModelProtocol {
    var favouriteMovieSet: ((Bool) -> Void)? { get set }
    
    var movie: Movie { get }
    var isFavouriteMovie: Bool { get }
    
    func updateFavourites()
}

// MARK: - Class Definition

class DetailsViewModel: DetailsViewModelProtocol {
    // MARK: - Public Callbacks
    
    public var favouriteMovieSet: ((Bool) -> Void)?
    
    // MARK: - Private Properties
    
    private(set) var movie: Movie
    private(set) var isFavouriteMovie: Bool = false {
        didSet {
            self.favouriteMovieSet?(isFavouriteMovie)
        }
    }
    
    private var favouritesCaretaker: FavouritesCaretaker
    
    // MARK: - Initializers
    
    init(movie: Movie, favouritesCaretaker: FavouritesCaretaker) {
        self.movie = movie
        self.favouritesCaretaker = favouritesCaretaker
        setUpFavourite()
    }
    
    // MARK: - Private Methods
    
    private func setUpFavourite() {
        isFavouriteMovie = favouritesCaretaker.favouriteMovies.contains(where: { movie.id == $0.id })
    }
    
    public func updateFavourites() {
        isFavouriteMovie ? favouritesCaretaker.deleteMovieFromFavourites(movie: movie.toPOCO) : favouritesCaretaker.addFavouriteMovie(movie: movie.toPOCO)
        isFavouriteMovie.toggle()
    }
}
