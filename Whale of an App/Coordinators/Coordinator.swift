//
//  Coordinator.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/25/21.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
