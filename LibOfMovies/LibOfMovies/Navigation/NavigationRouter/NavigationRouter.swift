//
//  NavigationRouter.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import Foundation
import UIKit

// MARK: - Protocol Definition

public protocol NavigationRouterProtocol {
    // MARK: - Generics
    
    associatedtype Parameters
    associatedtype RouteID
    
    // MARK: - Methods
    
    func navigate(to routeID: RouteID, from context: UIViewController, withParameters parameters: Parameters?)
}

// MARK: - Class Definition

open class NavigationRouter<ParameterType, RouteType>: NavigationRouterProtocol {
    // MARK: - Typealiases
    
    public typealias Parameters = ParameterType
    public typealias RouteID = RouteType
    
    // MARK: - Public Methods
    
    public func navigate(to routeID: RouteType, from context: UIViewController, withParameters parameters: ParameterType?) {}
}
