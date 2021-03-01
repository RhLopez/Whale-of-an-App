//
//  ImageLoader.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit

final class WhaleRemoteImageLoader: RemoteImageLoader {
    let imageCache = NSCache<NSString, UIImage>()
    let session: URLSession
    let baseURLString = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/"
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func fetchImage(withPath imagePath: String, completion: @escaping (RemoteImageResult) -> Void) {
        if let image = imageCache.object(forKey: NSString(string: imagePath)) {
            completion(.success(image))
        } else {
            fetchRemoteImage(withPath: imagePath, completion: completion)
        }
    }
    
    private func fetchRemoteImage(withPath imagePath: String, completion: @escaping (RemoteImageResult) -> Void) {
        guard let baseUrl = URL(string: baseURLString) else {
            completion(.error)
            return
        }
        
        let url = baseUrl.appendingPathComponent(imagePath)
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print("Error fetching remote imager: \(error)")
                completion(.error)
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(.error)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageCache.setObject(image, forKey: NSString(string: imagePath))
                completion(.success(image))
            }
        }.resume()
    }
}
