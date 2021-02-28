//
//  WhaleCollectionViewCell.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/26/21.
//

import UIKit
import Combine

class WhaleCollectionViewCell: UICollectionViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(nameLabel)
        
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        
        viewModel.fetchRemoteImage()
        
        nameLabel.text = viewModel.whaleName
        backgroundColor = viewModel.cellBackgroundColor
        
        bind(viewModel: viewModel)
    }
    
    private func bind(viewModel: WhaleCollectionCellViewModel) {
        viewModel.whaleImage
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &subscriptions)
        
        viewModel.loadingStatus
            .sink { [weak self] loadingStatus in
                self?.updateLoadingStatus(with: loadingStatus)
            }
            .store(in: &subscriptions)
    }
    
    private func updateLoadingStatus(with loadingStatus: LoadingStatus) {
        switch loadingStatus {
        case .loading:
            activityIndicator.startAnimating()
        case .iddle, .loaded:
            activityIndicator.stopAnimating()
        }
    }
}
