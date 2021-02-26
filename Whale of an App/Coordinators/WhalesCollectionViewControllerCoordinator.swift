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
    let dataProvider: DataProvider
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.dataProvider = JSONDataProvider(fileName: "WhaleData")
    }
    
    func start() {
        let viewModel = WhalesCollectionControllerViewModel(dataProvider: dataProvider)
        let viewController = WhalesCollectionViewController(viewModel: viewModel)
        
        rootViewController.view.addSubview(viewController.view)
        rootViewController.addChild(viewController)
        viewController.didMove(toParent: rootViewController)
    }
}
