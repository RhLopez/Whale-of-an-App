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
    private var datasource: UICollectionViewDiffableDataSource<WhaleCollectionViewSection, Whale>?
    private var subscriptions = Set<AnyCancellable>()
    
    private let whalesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        
        viewModel.fetchWhales()
    }
    
    private func bindViewModel() {
        viewModel.whales
            .sink { [weak self] whales in
                self?.updateDataSource(with: whales)
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
        let whaleCell = UICollectionView.CellRegistration<WhaleCollectionViewCell, Whale> { [weak self] cell, indexPath, _ in
            guard let self = self else { return }
            cell.viewModel = self.viewModel.cellViewModel(at: indexPath)
        }
        
        datasource = UICollectionViewDiffableDataSource<WhaleCollectionViewSection, Whale>(collectionView: whalesCollectionView, cellProvider: { collectionView, indexPath, whale -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: whaleCell, for: indexPath, item: whale)
        })
    }
    
    private func updateDataSource(with whales: [Whale]) {
        guard let datasource = datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<WhaleCollectionViewSection, Whale>()
        snapshot.appendSections([.main])
        snapshot.appendItems(whales, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}
 
// MARK: - UICollectionViewDelegate
extension WhalesCollectionViewController: UICollectionViewDelegate {
}

// MARK: - CollectionView Section Type
extension WhalesCollectionViewController {
    enum WhaleCollectionViewSection {
        case main
    }
}
