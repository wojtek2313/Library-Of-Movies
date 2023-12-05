//
//  MoviePOCO+Ext.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 05/12/2023.
//

import LibOfMoviesPersistence

extension MoviePOCO {
    var toModel: Movie {
        let model = Movie(id: self.id,
                          backdropPath: self.backdropPath,
                          title: self.title,
                          releaseDate: self.releaseDate,
                          voteAverage: self.voteAverage,
                          overview: self.overview)
        return model
    }
}

extension Movie {
    var toPOCO: MoviePOCO {
        let model = MoviePOCO(value: ["id": id,
                                      "backdropPath": backdropPath,
                                      "title": title,
                                      "releaseDate": releaseDate,
                                      "voteAverage": voteAverage,
                                      "overview": overview
                                     ])
        return model
    }
}
