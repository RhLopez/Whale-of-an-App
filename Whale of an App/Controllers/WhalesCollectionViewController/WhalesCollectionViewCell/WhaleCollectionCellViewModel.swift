//
//  WhaleCollectionCellViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit
import Combine

class WhaleCollectionCellViewModel {
    private let card: WhaleCard
    private let imageLoader: RemoteImageLoader
    let whaleImage = CurrentValueSubject<UIImage?, Never>(nil)
    let loadingStatus = CurrentValueSubject<LoadingStatus, Never>(.iddle)
    
    var whaleName: String {
        return card.whale.name
    }
    
    var cellBackgroundColor: UIColor? {
        return UIColor(hexString: card.backgroundColor)
    }
    
    init(card: WhaleCard, imageLoader: RemoteImageLoader) {
        self.card = card
        self.imageLoader = imageLoader
    }
    
    func fetchRemoteImage() {
        loadingStatus.send(.loading)
        
        imageLoader.fetchImage(withPath: card.whale.imagePath) { [weak self] result in
            var image: UIImage?
            
            switch result {
            case let .success(remoteImage):
                image = remoteImage
            case .error:
                image = UIImage(named: "placeholder")
            }
            
            self?.loadingStatus.send(.loaded)
            self?.whaleImage.send(image)
        }
    }
}
