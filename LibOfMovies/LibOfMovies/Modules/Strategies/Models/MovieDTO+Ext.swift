//
//  MovieDTO+Ext.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import LibOfMoviesNetwork

extension MovieDTO {
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
