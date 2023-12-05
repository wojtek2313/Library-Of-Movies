//
//  UIImageView+Ext.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import LibOfMoviesNetwork
import UIKit

extension UIImageView {
    func downloadImage(withParameter parameter: String) {
        Task { @MainActor in
            let image = try await NetworkManager.shared.fetchBackdropImage(withParameter: parameter)
            self.image = image
        }
    }
}
