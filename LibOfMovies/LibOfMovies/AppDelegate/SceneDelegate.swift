//
//  SceneDelegate.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Public Properties
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    // MARK: - App Liftime Methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// Start App Flow
        startAppFlow(at: scene)
    }
    
    // MARK: - Private Methods
    
    private func startAppFlow(at scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        navigationController = UINavigationController(rootViewController: createMainViewController())
        navigationController?.isNavigationBarHidden = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func createMainViewController() -> UIViewController {
        let viewController = MainViewController()
        return viewController
    }
}

