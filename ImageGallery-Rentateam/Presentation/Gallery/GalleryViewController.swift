//
//  GalleryViewController.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import UIKit

protocol GalleryViewControllerProtocol: NSObject {
    func reloadCollection()
}

final class GalleryViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        
        return collection
    }()
    
    private let galleryPresenter: GalleryPresenterProtocol
    
    init(galleryPresenter: GalleryPresenterProtocol = GalleryPresenter()) {
        self.galleryPresenter = galleryPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        galleryPresenter.setDelegate(self)
        
        setupCollectionViewPosition()
        galleryPresenter.fetchGalleryItems()
    }
    
    private func setupCollectionViewPosition() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

extension GalleryViewController: GalleryViewControllerProtocol {
    func reloadCollection() {
        collectionView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryPresenter.getImagesNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        galleryPresenter.setupCellInfo(cell: cell, row: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryItem = galleryPresenter.getItem(in: indexPath.row)
        let cacheService = galleryPresenter.getCacheService()
        let detailsViewController = ImageDetailsViewController(galleryItem: galleryItem,
                                                               imageCacheService: cacheService)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == galleryPresenter.getImagesNumber() {
            galleryPresenter.fetchGalleryItems()
        }
    }
}
