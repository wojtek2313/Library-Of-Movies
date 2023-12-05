//
//  MovieDTO.swift
//  LibOfMoviesNetwork
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation

public struct MovieDTO: Codable {
    public var id: Int
    public var backdropPath: String
    public var title: String
    public var releaseDate: String
    public var voteAverage: Double
    public var overview: String
}
