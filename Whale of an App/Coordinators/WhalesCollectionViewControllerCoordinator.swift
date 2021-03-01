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
    let imageLoader: RemoteImageLoader
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.dataProvider = JSONDataProvider()
        self.imageLoader = WhaleRemoteImageLoader()
    }
    
    func start() {
        let viewModel = WhalesCollectionControllerViewModel(dataProvider: dataProvider,
                                                            imageLoader: imageLoader)
        viewModel.delegate = self
        let viewController = WhalesCollectionViewController(viewModel: viewModel)
        
        rootViewController.view.addSubview(viewController.view)
        rootViewController.addChild(viewController)
        viewController.didMove(toParent: rootViewController)
    }
    
    func whaleCardDetailControllerCoordinator(whaleCard: WhaleCard) {
        let coordinator = WhaleCardDetailControllerCoordinator(whaleCard: whaleCard,
                                                               imageLoader: imageLoader,
                                                               rootViewController: rootViewController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}


//MARK: - WhalesCollectionControllerViewModelDelegate
extension WhalesCollectionViewControllerCoordinator: WhalesCollectionControllerViewModelDelegate {
    func didSelect(whaleCard: WhaleCard) {
        whaleCardDetailControllerCoordinator(whaleCard: whaleCard)
    }
}

// MARK: - WhaleCardDetailControllerCoordinatorDelegate
extension WhalesCollectionViewControllerCoordinator: WhaleCardDetailControllerCoordinatorDelegate {
    func whaleCardDetailControllerDismissed() {
        childCoordinators.removeAll(where: { $0 is WhaleCardDetailControllerCoordinator })
    }
}
