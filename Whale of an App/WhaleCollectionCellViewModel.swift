//
//  WhaleCollectionCellViewModel.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import Foundation

struct WhaleCollectionCellViewModel {
    let whale: Whale
    
    init(whale: Whale) {
        self.whale = whale
    }
    
    var whaleName: String {
        return whale.name
    }
}
