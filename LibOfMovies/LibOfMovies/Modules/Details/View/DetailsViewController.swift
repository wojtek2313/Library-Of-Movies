//
//  DetailsViewController.swift
//  LibOfMovies
//
//  Created by Wojciech Kulas on 05/12/2023.
//

import UIKit
import LibOfMoviesUI

class DetailsViewController: UIViewController {
    // MARK: - Private Properties
    
    private var viewModel: DetailsViewModelProtocol
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.downloadImage(withParameter: viewModel.movie.backdropPath)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.movie.title
        label.textAlignment = .left
        label.font = .avenirHeavyOpaqueTitle
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.addTarget(self, action: #selector(bindFavouriteButton(sender:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: viewModel.isFavouriteMovie ? "heart.fill" : "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.movie.releaseDate
        label.textAlignment = .left
        label.font = .avenirBlackOpaqueMinimalized
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(round(viewModel.movie.voteAverage))"
        label.textAlignment = .left
        label.font = .avenirBlackOpaqueMinimalized
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.text = viewModel.movie.overview
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Initializers
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifetime Methods
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews([imageView, titleLabel, favoriteButton, dateLabel, degreeLabel, overviewTextView])
    }
    
    private func addConstraints() {
        /// Image View Constraints
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: LibOfMoviesSize.largeImageSize).isActive = true
        
        /// Title Label Constraints
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LibOfMoviesSize.xsSize).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: LibOfMoviesSize.sSize).isActive = true
        
        /// Favorite Button Constraints
        favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LibOfMoviesSize.xsSize).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: LibOfMoviesSize.favouriteSize).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: LibOfMoviesSize.favouriteSize).isActive = true
        
        /// Date Label Constraints
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
        /// Degree Label Constraints
        degreeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        degreeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
        /// Overview Text View Constraints
        overviewTextView.topAnchor.constraint(equalTo: degreeLabel.bottomAnchor, constant: LibOfMoviesSize.xsSize).isActive = true
        overviewTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LibOfMoviesSize.sSize).isActive = true
        overviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LibOfMoviesSize.sSize).isActive = true
    }
}

// MARK: - Events

extension DetailsViewController {
    private func setupEvents() {
        bindFavorites()
    }
    
    private func bindFavorites() {
        viewModel.favouriteMovieSet = { [unowned self] isFavourite in
            favoriteButton.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"), for: .normal)
            favoriteButton.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"), for: .selected)
        }
    }
    
    @objc
    private func bindFavouriteButton(sender: UIButton) {
        viewModel.updateFavourites()
    }
}
