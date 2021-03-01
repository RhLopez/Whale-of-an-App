//
//  JSONDataProvider.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import Foundation

final class JSONDataProvider: DataProvider {
    struct WhaleData: Codable {
        let whales: [Whale]
    }
    
    struct BackgroundColor: Codable {
        struct ColorValue: Codable {
            let value: String
        }
        
        let colors: [ColorValue]
    }
    
    func fetchWhales(completion: @escaping ([Whale]) -> Void) {
        fetchDataFromBundle(with: "WhaleData", withExtension: ".json") { data in
            let decoder = JSONDecoder()
            
            guard let whaleData = try? decoder.decode(WhaleData.self, from: data) else {
                fatalError("Failed to decode Whale Data from bundle")
            }
            
            completion(whaleData.whales)
        }
    }
    
    func fetchCardBackgroundColors(completion: @escaping ([String]) -> Void) {
        fetchDataFromBundle(with: "CardBackgroundColors", withExtension: ".json") { data in
            let decoder = JSONDecoder()
            
            guard let colorsData = try? decoder.decode(BackgroundColor.self, from: data) else {
                fatalError("Failed to decode Background Colors data from bundle")
            }
            
            let colors = colorsData.colors.map { $0.value }
            completion(colors)
        }
    }
    
    private func fetchDataFromBundle(with fileName: String, withExtension fileExtension: String, completion: @escaping (Data) -> Void) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Failed to locate \(fileName) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName) from bundle")
        }
        
        completion(data)
    }
}
