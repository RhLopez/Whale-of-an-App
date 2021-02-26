//
//  JSONDataProvider.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import Foundation

final class JSONDataProvider: DataProvider {
    let fileName: String
    
    struct WhaleData: Codable {
        let whales: [Whale]
    }
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func fetchWhales() -> [Whale] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".json") else {
            fatalError("Failed to locate \(fileName) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let whaleData = try? decoder.decode(WhaleData.self, from: data) else {
            fatalError("Failed to decode \(fileName) from bundle")
        }
        
        return whaleData.whales
    }
}
