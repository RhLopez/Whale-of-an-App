//
//  WhalesCollectionViewController.swift
//  Whale of an App
//
//  Created by Ramiro H. Lopez on 2/25/21.
//

import UIKit
import Combine

class WhalesCollectionViewController: UIViewController {
    private let viewModel: WhalesCollectionControllerViewModel
    private var datasource: UICollectionViewDiffableDataSource<WhaleCollectionViewSection, WhaleCard>?
    private var subscriptions = Set<AnyCancellable>()
    
    private let whalesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indiciator = UIActivityIndicatorView(style: .medium)
        indiciator.translatesAutoresizingMaskIntoConstraints = false
        return indiciator
    }()
    
    init(viewModel: WhalesCollectionControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewModel.backgroundColor
        configureCollectionView()
        configureViewHierarchy()
        configureDataSource()
        bindViewModel()
        
        viewModel.fetchData()
    }
    
    private func bindViewModel() {
        viewModel.whaleCards
            .sink { [weak self] cards in
                self?.updateDataSource(with: cards)
            }
            .store(in: &subscriptions)
        
        viewModel.loadingStatus
            .sink { [weak self] loadingStatus in
                self?.updateLoadingStatus(with: loadingStatus)
            }
            .store(in: &subscriptions)
    }
    
    private func configureCollectionView() {
        whalesCollectionView.collectionViewLayout = createCollectionViewLayout()
        whalesCollectionView.delegate = self
    }
    
    private func configureViewHierarchy() {
        view.addSubview(whalesCollectionView)
        
        NSLayoutConstraint.activate([
            whalesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whalesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whalesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            whalesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateLoadingStatus(with loadingStatus: LoadingStatus) {
        switch loadingStatus {
        case .loading:
            activityIndicator.startAnimating()
        case .loaded, .iddle:
            activityIndicator.stopAnimating()
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let whaleCell = UICollectionView.CellRegistration<WhaleCollectionViewCell, WhaleCard> { [weak self] cell, indexPath, _ in
            guard let self = self else { return }
            cell.viewModel = self.viewModel.cellViewModel(at: indexPath)
        }
        
        datasource = UICollectionViewDiffableDataSource<WhaleCollectionViewSection, WhaleCard>(collectionView: whalesCollectionView, cellProvider: { collectionView, indexPath, whale -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: whaleCell, for: indexPath, item: whale)
        })
    }
    
    private func updateDataSource(with cards: [WhaleCard]) {
        guard let datasource = datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<WhaleCollectionViewSection, WhaleCard>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cards, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}
 
// MARK: - UICollectionViewDelegate
extension WhalesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

// MARK: - CollectionView Section Type
extension WhalesCollectionViewController {
    enum WhaleCollectionViewSection {
        case main
    }
}
