//
//  MainViewController.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 04/12/2023.
//

import UIKit
import LibOfMoviesUI

class MainViewController: UIViewController {
    // MARK: - Constants
    
    private struct Constants {
        static let numberOfColumnsInCollectionView = 2
        static let minimumInterItemSpacing: CGFloat = 8
        static let minimumLineSpacing: CGFloat = 5
        static let customItemWidth: CGFloat = 150
        static let customItemHeight: CGFloat = 150
    }
    
    // MARK: - Private Properties
    
    private var viewModel: MainViewModelProtocol
    private var router: NavigationRouter<Movie, DetailsNavigationType>
    
    // MARK: - UI
    
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["all_section".localized, "favourites_section".localized])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(bindSegmentedControl(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var collectionView: UICollectionView = {
        /// CollectionViewFlowLayout
        let collectionViewFlowLayout = LibOfMoviesCollectionViewFlowLayout(
            numberOfColumns: Constants.numberOfColumnsInCollectionView,
            minimumInteritemSpacing: Constants.minimumInterItemSpacing,
            minimumLineSpacing: Constants.minimumLineSpacing,
            customItemWidth: Constants.customItemWidth,
            customItemHeight: Constants.customItemHeight
        )
        collectionViewFlowLayout.scrollDirection = .vertical
        /// CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let cellReuseIdentifier = String(describing: MainCollectionViewCell.self)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(viewModel: MainViewModelProtocol, router: NavigationRouter<Movie, DetailsNavigationType>) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifetime Methods
    
    override func loadView() {
        super.loadView()
        setupView()
        setupEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews([segmentedControl, collectionView])
    }
    
    private func addConstraints() {
        /// Segmented Control Constraints
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LibOfMoviesSize.mSize).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LibOfMoviesSize.large).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LibOfMoviesSize.large).isActive = true
        
        /// Collection View Constraints
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: LibOfMoviesSize.mSize).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: LibOfMoviesSize.zero).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LibOfMoviesSize.xxsSize).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LibOfMoviesSize.xxsSize).isActive = true
    }
}

// MARK: - Collection View Delegate && Collection View Data Source

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellReuseIdentifier = String(describing: MainCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.movies[indexPath.row]
        cell.configure(with: model)
        cell.onFavouriteTapped = { [unowned self] in
            self.viewModel.toggleFavourites(movie: model)
        }
        cell.isFavourite = viewModel.favouriteMovies.contains(where: { model.id == $0.id })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.movies[indexPath.row]
        viewModel.selectedItem?(item)
    }
}

// MARK: - Events

extension MainViewController {
    private func setupEvents() {
        bindRefreshCollection()
        bindOnCellTap()
    }

    @objc
    private func bindSegmentedControl(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        viewModel.selectedIndex?(selectedIndex)
        collectionView.reloadData()
    }

    private func bindRefreshCollection() {
        viewModel.refreshCollection = { [unowned self] in
            self.collectionView.reloadData()
        }
    }
    
    private func bindOnCellTap() {
        viewModel.selectedItem = { [unowned self] selectedItem in
            self.router.navigate(to: .details, from: self, withParameters: selectedItem)
        }
    }
}
