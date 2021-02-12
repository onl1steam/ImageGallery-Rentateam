//
//  ImageDetailsViewController.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    private enum ImageDetailsConstraints {
        static let buttonWidth: CGFloat = 25
        static let buttonHeight: CGFloat = 25
        static let imageWidth: CGFloat = 350
        static let imageHeight: CGFloat = 350
    }
    
    private let galleryItem: GalleryItem
    private let imageCacheService: ImageCacheServiceProtocol
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    init(galleryItem: GalleryItem,
         imageCacheService: ImageCacheServiceProtocol = ImageCacheService()) {
        self.galleryItem = galleryItem
        self.imageCacheService = imageCacheService
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setInitialInfo()
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setInitialInfo() {
        titleLabel.text = galleryItem.imageDescription
        dateLabel.text = "Время загрузки: \(galleryItem.loadingDate.getFormatted())"
        guard let imageData = imageCacheService.loadImageFromCache(key: galleryItem.id) else { return }
        DispatchQueue.global().async { [weak self] in
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        setupCloseButtonConstraints()
        setupImageViewConstraints()
        setupTitleLabelConstraints()
        setupDateLabelConstraints()
    }
    
    private func setupCloseButtonConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: ImageDetailsConstraints.buttonWidth),
            closeButton.widthAnchor.constraint(equalToConstant: ImageDetailsConstraints.buttonHeight),
            closeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: ImageDetailsConstraints.imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: ImageDetailsConstraints.imageWidth),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
}

extension Date {
    func getFormatted() -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm E, d MMM y"
        formatter1.locale = Locale(identifier: "ru_RU")
        return formatter1.string(from: self)
    }
}
