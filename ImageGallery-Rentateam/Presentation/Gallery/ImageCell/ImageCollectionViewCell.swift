//
//  ImageCollectionViewCell.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import UIKit

protocol ImageCollectionViewCellProtocol {
    func setLabel(_ text: String)
    func setImage(imageData: Data)
    func setDataTask(_ dataTask: URLSessionDataTask?)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    private enum CellConstraints {
        static let imageViewHeight: CGFloat = 150
        static let imageViewWidth: CGFloat = 150
    }
    
    static let reuseIdentifier = String(describing: ImageCollectionViewCell.self)
    private var dataTask: URLSessionDataTask?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCellSubviews()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
    }
    
    // MARK: Private Methods
    
    private func addCellSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupCellConstraints() {
        setupImageViewPositionConstraints()
        setupTitleLabelConstraints()
    }
    
    private func setupImageViewPositionConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: CellConstraints.imageViewHeight),
            imageView.widthAnchor.constraint(equalToConstant: CellConstraints.imageViewWidth),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

extension ImageCollectionViewCell: ImageCollectionViewCellProtocol {
    
    func setDataTask(_ dataTask: URLSessionDataTask?) {
        self.dataTask = dataTask
    }
    
    func setImage(imageData: Data) {
        DispatchQueue.global().async { [weak self] in
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    func setLabel(_ text: String) {
        titleLabel.text = text
    }
}
