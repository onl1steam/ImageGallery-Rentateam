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
    func getItem(in row: Int) -> GalleryItem
    func getCacheService() -> ImageCacheServiceProtocol
}

final class GalleryPresenter: GalleryPresenterProtocol {
    
    private let galleryService: GalleryServiceProtocol
    private let imageService: ImageServiceProtocol
    private let galleryStoreService: GalleryStoreServiceProtocol
    private let imageStoreService: ImageStoreServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    private var data: [GalleryItem]
    
    private var page: Int = 1
    private var itemsPerPage: Int = 20
    
    weak var galleryViewControlller: GalleryViewControllerProtocol?
    
    init(galleryService: GalleryServiceProtocol = GalleryService(),
         galleryStoreService: GalleryStoreServiceProtocol = GalleryStoreService(),
         imageStoreService: ImageStoreServiceProtocol = ImageStoreService(),
         imageCacheService: ImageCacheServiceProtocol = ImageCacheService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.galleryService = galleryService
        self.imageService = imageService
        self.galleryStoreService = galleryStoreService
        self.imageStoreService = imageStoreService
        self.imageCacheService = imageCacheService
        self.data = []
    }
    
    func getCacheService() -> ImageCacheServiceProtocol {
        return imageCacheService
    }
    
    func setDelegate(_ delegate: GalleryViewControllerProtocol) {
        galleryViewControlller = delegate
    }
    
    func fetchGalleryItems() {
        galleryService.fetchGallery(page: page, imagesPerPage: itemsPerPage) { [unowned self] response in
            self.page += 1
            switch response {
            case .success(let json):
                do {
                    let galleryData = try JSONDecoder().decode([GalleryResponse].self, from: json)
                    galleryData.forEach { response in
                        let galleryItem = GalleryItem(galleryResponse: response)
                        self.data.append(galleryItem)
                    }
                    self.galleryViewControlller?.reloadCollection()
                    self.galleryStoreService.saveGallery(self.data)
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            case .failure:
                self.galleryStoreService.getGallery { gallery in
                    self.data = gallery
                    self.galleryViewControlller?.reloadCollection()
                }
            }
        }
    }
    
    func getImagesNumber() -> Int {
        return data.count
    }
    
    func setupCellInfo(cell: ImageCollectionViewCellProtocol, row: Int) {
        cell.setLabel(data[row].imageDescription)
        if let imageData = imageCacheService.loadImageFromCache(key: data[row].id) {
            cell.setImage(imageData: imageData)
        } else if let data = imageStoreService.loadImage(key: data[row].id) {
            imageCacheService.cacheImage(key: self.data[row].id, image: data)
            cell.setImage(imageData: data)
        } else {
            let dataTask = imageService.fetchImage(urlString: data[row].imageUrl, completion: { [unowned self] response in
                    switch response {
                    case .success(let data):
                        self.imageCacheService.cacheImage(key: self.data[row].id, image: data)
                        self.imageStoreService.saveImage(key: self.data[row].id, imageData: data)
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
    
    func getItem(in row: Int) -> GalleryItem {
        return data[row]
    }
}
