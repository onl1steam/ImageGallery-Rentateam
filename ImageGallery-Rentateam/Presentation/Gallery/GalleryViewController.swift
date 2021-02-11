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
        
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewPosition()
        
        let galleryService: GalleryServiceProtocol = GalleryService()
        let urlString = "https://api.unsplash.com/photos/?client_id=6g-UBx5WMaXIWFxJVdVTdZ0XjOJbyflcYFsAUFlkRXs&page=1"
        galleryService.fetchGallery(urlString: urlString) { response in
            switch response {
            case .success(let json):
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: json, options: []) as! [[String : Any]]
                    print("JSON: \(jsonData)")
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
