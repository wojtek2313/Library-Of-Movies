//
//  MoviePOCO.swift
//  LibOfMoviesPersistence
//
//  Created by Wojciech Kulas on 05/12/2023.
//

import Foundation
import RealmSwift

public class MoviePOCO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var backdropPath: String
    @Persisted public var title: String
    @Persisted public var releaseDate: String
    @Persisted public var voteAverage: Double
    @Persisted public var overview: String
}
