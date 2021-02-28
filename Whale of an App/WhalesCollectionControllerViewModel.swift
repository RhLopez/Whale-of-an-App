//
//  WhalesCollectionControllerViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit
import Combine

class WhalesCollectionControllerViewModel {
    private let dataProvider: DataProvider
    private let imageLoader: RemoteImageLoader
    private let cellBackgroundColors = [
        UIColor.systemGreen,
        UIColor.orange,
        UIColor.red,
        UIColor.purple
    ]
    let whales = CurrentValueSubject<[Whale], Never>([])
    let backgroundColor = UIColor.systemBackground
    
    init(dataProvider: DataProvider, imageLoader: RemoteImageLoader) {
        self.dataProvider = dataProvider
        self.imageLoader = imageLoader
    }
    
    func fetchWhales() {
        dataProvider.fetchWhales { [weak self] whales in
            self?.whales.send(whales)
        }
    }
    
    func cellViewModel(at indexPath: IndexPath) -> WhaleCollectionCellViewModel {
        let item = indexPath.item
        let index = item < cellBackgroundColors.count ? item : item % cellBackgroundColors.count
        let backgroundColor = cellBackgroundColors[index]
        let whale = whales.value[indexPath.item]
        return WhaleCollectionCellViewModel(whale: whale, backgroundColor: backgroundColor, imageLoader: imageLoader)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
    }
}
