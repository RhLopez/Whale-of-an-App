//
//  WhaleCardDetailControllerCoordinator.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/28/21.
//

import UIKit

protocol WhaleCardDetailControllerCoordinatorDelegate: class {
    func whaleCardDetailControllerDismissed()
}

final class WhaleCardDetailControllerCoordinator: Coordinator {
    private let whaleCard: WhaleCard
    private let imageLoader: RemoteImageLoader
    private let rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    weak var delegate: WhaleCardDetailControllerCoordinatorDelegate?
    
    init(whaleCard: WhaleCard, imageLoader: RemoteImageLoader, rootViewController: UIViewController) {
        self.whaleCard = whaleCard
        self.imageLoader = imageLoader
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewModel = WhaleCardDetailControllerViewModel(whaleCard: whaleCard,
                                                           imageLoader: imageLoader)
        let viewController = WhaleCardDetailViewController(viewModel: viewModel)
        viewController.delegate = self
        rootViewController.present(viewController, animated: true, completion: nil)
    }
}

extension WhaleCardDetailControllerCoordinator: WhaleCardDetailControllerDelegate {
    func viewControllerDismissed() {
        delegate?.whaleCardDetailControllerDismissed()
    }
}
