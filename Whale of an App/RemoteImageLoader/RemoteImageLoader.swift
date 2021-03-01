//
//  RemoteImageLoader.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/27/21.
//

import UIKit

enum RemoteImageResult {
    case success(UIImage)
    case error
}

protocol RemoteImageLoader {
    func fetchImage(withPath imagePath: String, completion: @escaping (RemoteImageResult) -> Void)
}
