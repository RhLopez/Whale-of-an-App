//
//  DataProvider.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import Foundation

protocol DataProvider {
    func fetchWhales() -> [Whale]
}
