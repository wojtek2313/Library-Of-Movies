//
//  URLFactory.swift
//  LibOfMoviesNetwork
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation

// MARK: - Protocol Definition

public protocol URLFactoryProtocol {
    func create(_ responderType: ResponderType, withParameter parameter: String?, atPage page: Int?) -> URL?
}

public struct URLFactory: URLFactoryProtocol {
    // MARK: - Public Methods
    
    public func create(_ responderType: ResponderType, withParameter parameter: String? = nil, atPage page: Int? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = responderType.scheme
        components.host = responderType.host
        components.path = responderType.generatePath(withParameter: parameter)
        components.queryItems = responderType.generateQueryItems(atPage: page)
        return components.url
    }
}
