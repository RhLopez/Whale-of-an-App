//
//  WhaleCardDetailViewController.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/28/21.
//

import UIKit
import Combine

protocol WhaleCardDetailControllerDelegate: class {
    func viewControllerDismissed()
}

class WhaleCardDetailViewController: UIViewController {
    private let viewModel: WhaleCardDetailControllerViewModel
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: WhaleCardDetailControllerDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: WhaleCardDetailControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewHierarchy()
        viewModel.fetchRemoteImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.viewControllerDismissed()
    }
    
    private func configureViewHierarchy() {
        let contentStackView = UIStackView()
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.axis = .vertical
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 20
        
        view.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        view.backgroundColor = viewModel.cardBackgroundColor
        nameLabel.text = viewModel.whaleName
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.whaleImage
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &subscriptions)
    }
}
