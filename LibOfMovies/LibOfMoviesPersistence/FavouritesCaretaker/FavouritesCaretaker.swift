//
//  FavouritesCaretaker.swift
//  LibOfMoviesPersistence
//
//  Created by Wojciech Kulas on 05/12/2023.
//

import Foundation
import RealmSwift

// MARK: - Protocol Definition

public protocol FavouritesCaretakerProtocol {
    func openRealm()
    func addFavouriteMovie(movie: MoviePOCO)
    func deleteMovieFromFavourites(movie: MoviePOCO)
    func getFavouriteMovies()
    var favouriteMovies: [MoviePOCO] { get }
}

// MARK: - Class Definition

public class FavouritesCaretaker: FavouritesCaretakerProtocol {
    // MARK: - Public Properties
    
    public static let shared = FavouritesCaretaker()
    
    // MARK: - Private Properties
    
    private(set) var realm: Realm?
    public private(set) var favouriteMovies: [MoviePOCO] = []
    
    // MARK: - Initializers
    
    private init() {
        openRealm()
        getFavouriteMovies()
    }
    
    // MARK: - Public Methods
    
    public func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            print("Error opening realm: \(error)")
        }
    }
    
    public func addFavouriteMovie(movie: MoviePOCO) {
        guard let realm = realm else { return }
        try? realm.write {
            realm.add(movie)
            getFavouriteMovies()
        }
    }
    
    public func deleteMovieFromFavourites(movie: MoviePOCO) {
        guard let realm = realm else { return }
        let movieToDelete = realm.objects(MoviePOCO.self).filter(NSPredicate(format: "id = %@", NSNumber(value: movie.id)))
        try? realm.write {
            realm.delete(movieToDelete)
            getFavouriteMovies()
        }
    }
    
    public func getFavouriteMovies() {
        guard let realm = realm else { return }
        let favouriteMovies = realm.objects(MoviePOCO.self)
        self.favouriteMovies = []
        favouriteMovies.forEach { [weak self] movie in
            guard let self = self else { return }
            self.favouriteMovies.append(movie)
        }
    }
}
