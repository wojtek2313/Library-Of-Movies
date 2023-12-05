//
//  UIView+Ext.swift
//  LibOfMoviesUI
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
