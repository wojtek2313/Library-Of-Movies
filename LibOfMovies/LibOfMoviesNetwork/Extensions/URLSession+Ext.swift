//
//  URLSession+Ext.swift
//  LibOfMoviesNetwork
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation

public extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation{ continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
