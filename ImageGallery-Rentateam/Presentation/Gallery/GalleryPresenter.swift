//
//  GalleryPresenter.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

protocol GalleryPresenterProtocol {
    func getImagesNumber() -> Int
    func setupCellInfo(cell: ImageCollectionViewCellProtocol, row: Int)
    func fetchGalleryItems()
    func setDelegate(_ delegate: GalleryViewControllerProtocol)
}

final class GalleryPresenter: GalleryPresenterProtocol {
    
    private let galleryService: GalleryServiceProtocol
    private let imageService: ImageServiceProtocol
    private var data: [GalleryResponse]
    
    weak var galleryViewControlller: GalleryViewControllerProtocol?
    
    init(galleryService: GalleryServiceProtocol = GalleryService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.galleryService = galleryService
        self.imageService = imageService
        self.data = []
    }
    
    func setDelegate(_ delegate: GalleryViewControllerProtocol) {
        galleryViewControlller = delegate
    }
    
    func fetchGalleryItems() {
        galleryService.fetchGallery(page: 1, imagesPerPage: 10) { [weak self] response in
            switch response {
            case .success(let json):
                do {
                    self?.data = try JSONDecoder().decode([GalleryResponse].self, from: json)
                    self?.galleryViewControlller?.reloadCollection()
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getImagesNumber() -> Int {
        return data.count
    }
    
    func setupCellInfo(cell: ImageCollectionViewCellProtocol, row: Int) {
        cell.setLabel(data[row].imageDescription)
        let dataTask = imageService.fetchImage(urlString: data[row].urls.regular, completion: { response in
                switch response {
                case .success(let data):
                    cell.setImage(imageData: data)
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Image loading failed: \(error.localizedDescription)")
                    }
                }
            }
        )
        cell.setDataTask(dataTask)
    }
}
