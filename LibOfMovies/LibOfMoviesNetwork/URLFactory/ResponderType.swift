//
//  ResponderType.swift
//  LibOfMoviesNetwork
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation

// MARK: - Struct Definition

fileprivate struct APIConstants {
    static let apiKey: String = "c5259c99c38044a347327a8a2c66d335"
}

// MARK: - Enum Definition

public enum ResponderType {
    case image, movie
    
    public var scheme: String {
        return "https"
    }
    
    public var host: String {
        switch self {
        case .image: return "image.tmdb.org"
        case .movie : return "api.themoviedb.org"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .image: return []
        case .movie: return [URLQueryItem(name: "api_key", value: APIConstants.apiKey)]
        }
    }
    
    public func generatePath(withParameter parameter: String? = nil) -> String {
        switch self {
        case .image:
            return "/t/p/w500/\(parameter ?? "")"
        case .movie:
            return "/3/movie/now_playing"
        }
    }
}
