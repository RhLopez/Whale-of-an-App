//
//  AppCoordinator.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/25/21.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        whalesCollectionControllerCoordinator(rootViewController: rootViewController)
    }
    
    func whalesCollectionControllerCoordinator(rootViewController: UIViewController) {
        let coordinator = WhalesCollectionViewControllerCoordinator(rootViewController: rootViewController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
