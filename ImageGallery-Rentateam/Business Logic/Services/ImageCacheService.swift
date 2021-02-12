//
//  ImageCacheService.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 12.02.2021.
//

import Foundation

protocol ImageCacheServiceProtocol {
    func loadImageFromCache(key: String) -> Data?
    func cacheImage(key: String, image: Data)
    func deleteFromCache(key: String)
}

final class ImageCacheService: ImageCacheServiceProtocol {
    
    private let imageCache = NSCache<NSString, NSData>()
    
    func loadImageFromCache(key: String) -> Data? {
        let imageKey = NSString(string: key)
        guard let image = imageCache.object(forKey: imageKey) else { return nil }
        let data = Data(referencing: image)
        return data
    }
    
    func cacheImage(key: String, image: Data) {
        let imageKey = NSString(string: key)
        let imageData = image as NSData
        imageCache.setObject(imageData, forKey: imageKey)
    }
    
    func deleteFromCache(key: String) {
        let imageKey = NSString(string: key)
        imageCache.removeObject(forKey: imageKey)
    }
}
