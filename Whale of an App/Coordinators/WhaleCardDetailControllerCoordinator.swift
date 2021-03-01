//
//  WhaleCardDetailControllerCoordinator.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/28/21.
//

import UIKit

final class WhaleCardDetailControllerCoordinator: Coordinator {
    private let card: WhaleCard
    private let rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    
    init(card: WhaleCard, rootViewController: UIViewController) {
        self.card = card
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewController = WhaleCardDetailViewController()
        rootViewController.present(viewController, animated: true, completion: nil)
    }
}
