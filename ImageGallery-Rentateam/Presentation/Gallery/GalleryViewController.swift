//
//  GalleryViewController.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collection.register(ImageCollectionViewCell.self,
                            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        
        return collection
    }()
    
    private let galleryService: GalleryServiceProtocol
    private let imageService: ImageServiceProtocol
    private var data: [GalleryItem] = []
    
    init(galleryService: GalleryServiceProtocol = GalleryService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.galleryService = galleryService
        self.imageService = imageService
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
        
        setupCollectionViewPosition()
        let urlString = "https://api.unsplash.com/photos/?client_id=6g-UBx5WMaXIWFxJVdVTdZ0XjOJbyflcYFsAUFlkRXs&page=1"
        galleryService.fetchGallery(urlString: urlString) { [weak self] response in
            switch response {
            case .success(let json):
                do {
                    self?.data = try JSONDecoder().decode([GalleryItem].self, from: json)
                    self?.collectionView.reloadData()
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
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

extension GalleryViewController: UICollectionViewDelegate {}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setLabel(data[indexPath.row].imageDescription)
        cell.dataTask = imageService.fetchImage(urlString: data[indexPath.row].urls.regular, completion: { response in
                switch response {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.setImage(image)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Image loading failed: \(error.localizedDescription)")
                    }
                }
            }
        )
        return cell
    }
}
