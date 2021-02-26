//
//  WhalesCollectionViewControllerCoordinator.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/25/21.
//

import UIKit

final class WhalesCollectionViewControllerCoordinator: Coordinator {
    private let rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewController = WhalesCollectionViewController()
        
        rootViewController.view.addSubview(viewController.view)
        rootViewController.addChild(viewController)
        viewController.didMove(toParent: rootViewController)
    }
}
