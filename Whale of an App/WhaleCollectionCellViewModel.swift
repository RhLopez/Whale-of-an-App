//
//  WhaleCollectionCellViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit
import Combine

enum LoadingStatus {
    case loading
    case loaded
    case iddle
}

class WhaleCollectionCellViewModel {
    private let whale: Whale
    private let backgroundColor: UIColor
    private let imageLoader: RemoteImageLoader
    let whaleImage = CurrentValueSubject<UIImage?, Never>(nil)
    let loadingStatus = CurrentValueSubject<LoadingStatus, Never>(.iddle)
    
    var whaleName: String {
        return whale.name
    }
    
    var cellBackgroundColor: UIColor {
        return backgroundColor
    }
    
    init(whale: Whale, backgroundColor: UIColor, imageLoader: RemoteImageLoader) {
        self.whale = whale
        self.backgroundColor = backgroundColor
        self.imageLoader = imageLoader
    }
    
    func fetchRemoteImage() {
        loadingStatus.send(.loading)
        
        imageLoader.fetchImage(withPath: whale.imagePath) { [weak self] result in
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
