//
//  NetworkManager.swift
//  LibOfMoviesNetwork
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import UIKit

// MARK: - Error

public enum NetworkError: Error {
    case wrongURL
    case couldntFetchData
    case couldntFetchImage
}

// MARK: - Protocol Definition

public protocol NetworkManagerProtocol {
    static var shared: NetworkManager { get }
    
    func fetchNowPlaying(atPage page: Int) async throws -> [MovieDTO]
    func fetchBackdropImage(withParameter parameter: String) async throws -> UIImage
}

// MARK: - Class Definition

@globalActor
public final actor NetworkManager: NetworkManagerProtocol {
    // MARK: - Public Properties
    
    public static let shared: NetworkManager = NetworkManager()
    
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let urlFactory: URLFactoryProtocol
    
    // MARK: - Initializer
    
    private init() {
        urlFactory = URLFactory()
    }
    
    // MARK: - Public Methods
    
    public func fetchNowPlaying(atPage page: Int) async throws -> [MovieDTO] {
        var decodedMovies: [MovieDTO] = []
        guard let url = urlFactory.create(.movie, withParameter: nil, atPage: page) else { throw NetworkError.wrongURL }
        do {
            let (data, _) = try await session.data(from: url)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decodedMovies = try decoder.decode(ResultsDTO.self, from: data).results
        }
        return decodedMovies
    }
    
    public func fetchBackdropImage(withParameter parameter: String) async throws -> UIImage {
        var backdropImage = UIImage()
        guard let url = urlFactory.create(.image, withParameter: parameter, atPage: nil) else { throw NetworkError.wrongURL }
        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else { throw NetworkError.couldntFetchImage }
            backdropImage = image
        }
        return backdropImage
    }
}
