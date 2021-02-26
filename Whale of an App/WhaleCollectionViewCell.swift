//
//  WhaleCollectionViewCell.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit

class WhaleCollectionViewCell: UICollectionViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var viewModel: WhaleCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func updateCell() {
    }
}
