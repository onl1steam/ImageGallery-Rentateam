//
//  GalleryStoreService.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 12.02.2021.
//

import Foundation

protocol GalleryStoreServiceProtocol {
    func saveGallery(_ gallery: [GalleryItem])
    func getGallery(completion: @escaping (_ gallery: [GalleryItem]) -> Void)
}

final class GalleryStoreService: GalleryStoreServiceProtocol {
    
    func saveGallery(_ gallery: [GalleryItem]) {
        DispatchQueue.global().async {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(gallery), forKey:"galleryList")
        }
    }
    
    func getGallery(completion: @escaping (_ gallery: [GalleryItem]) -> Void) {
        DispatchQueue.global().async {
            guard let data = UserDefaults.standard.value(forKey:"galleryList") as? Data,
                let galleryList = try? PropertyListDecoder().decode(Array<GalleryItem>.self, from: data) else {
                completion([])
                return
            }
            DispatchQueue.main.async {
                completion(galleryList)
            }
        }
    }
}
