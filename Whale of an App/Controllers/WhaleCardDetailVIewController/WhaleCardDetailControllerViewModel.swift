//
//  WhaleCardDetailControllerViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/28/21.
//

import UIKit
import Combine

final class WhaleCardDetailControllerViewModel {
    private let whaleCard: WhaleCard
    private let imageLoader: RemoteImageLoader
    let whaleImage = CurrentValueSubject<UIImage?, Never>(nil)
    
    var cardBackgroundColor: UIColor {
        return UIColor(hexString: whaleCard.backgroundColor)
    }
    
    var whaleName: String {
        whaleCard.whale.name
    }
    
    init(whaleCard: WhaleCard, imageLoader: RemoteImageLoader) {
        self.whaleCard = whaleCard
        self.imageLoader = imageLoader
    }
    
    func fetchRemoteImage() {
        imageLoader.fetchImage(withPath: whaleCard.whale.imagePath) { [weak self] imageResult in
            var image: UIImage?
            
            switch imageResult {
            case let .success(remoteImage):
                image = remoteImage
            case .error:
                image = UIImage(named: "placeholder")
            }
            
            self?.whaleImage.send(image)
        }
    }
}
