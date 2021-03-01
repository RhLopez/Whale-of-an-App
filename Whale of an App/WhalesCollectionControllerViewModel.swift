//
//  WhalesCollectionControllerViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit
import Combine

protocol WhalesCollectionControllerViewModelDelegate: class {
    func didSelect(card: WhaleCard)
}

class WhalesCollectionControllerViewModel {
    private let dataProvider: DataProvider
    private let imageLoader: RemoteImageLoader
    private let whales = PassthroughSubject<[Whale], Never>()
    private let backgroundColors = PassthroughSubject<[String], Never>()
    private var subscriptions = Set<AnyCancellable>()
    let whaleCards = CurrentValueSubject<[WhaleCard], Never>([])
    let loadingStatus = CurrentValueSubject<LoadingStatus, Never>(.iddle)
    
    var backgroundColor: UIColor {
        return .systemBackground
    }
    
    weak var delegate: WhalesCollectionControllerViewModelDelegate?
    
    init(dataProvider: DataProvider, imageLoader: RemoteImageLoader) {
        self.dataProvider = dataProvider
        self.imageLoader = imageLoader
        
        whales
            .zip(backgroundColors)
            .sink {[weak self] whales, backgroundColors in
                self?.createCards(withWhales: whales, backgroundColors: backgroundColors)
            }
            .store(in: &subscriptions)
    }
    
    func fetchData() {
        loadingStatus.send(.loading)
        fetchWhales()
        fetchCardBackgroundColors()
    }
    
    private func fetchWhales() {
        dataProvider.fetchWhales { [weak self] whales in
            self?.whales.send(whales)
        }
    }
    
    private func fetchCardBackgroundColors() {
        dataProvider.fetchCardBackgroundColors { [weak self] colors in
            self?.backgroundColors.send(colors)
        }
    }
    
    private func createCards(withWhales whales: [Whale], backgroundColors: [String]) {
        var cards: [WhaleCard] = []
        
        for (index, whale) in whales.enumerated() {
            let colorIndex = index < backgroundColors.count ? index : index % backgroundColors.count
            let card = WhaleCard(whale: whale, backgroundColor: backgroundColors[colorIndex])
            cards.append(card)
        }
        
        loadingStatus.send(.loaded)
        whaleCards.send(cards)
    }
    
    func cellViewModel(at indexPath: IndexPath) -> WhaleCollectionCellViewModel {
        let card = whaleCards.value[indexPath.item]
        return WhaleCollectionCellViewModel(card: card, imageLoader: imageLoader)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let card = whaleCards.value[indexPath.item]
        delegate?.didSelect(card: card)
    }
}
