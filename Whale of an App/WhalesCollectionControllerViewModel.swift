//
//  WhalesCollectionControllerViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import Foundation
import Combine

class WhalesCollectionControllerViewModel {
    let dataProvider: DataProvider
    let whales = CurrentValueSubject<[Whale], Never>([])
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchWhales() {
        dataProvider.fetchWhales { [weak self] whales in
            self?.whales.send(whales)
        }
    }
}
