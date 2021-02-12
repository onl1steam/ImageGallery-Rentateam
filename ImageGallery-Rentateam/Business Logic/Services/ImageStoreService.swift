//
//  ImageCache.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 12.02.2021.
//

import UIKit

protocol ImageStoreServiceProtocol {
    func loadImage(key: String) -> Data?
    func saveImage(key: String, imageData: Data)
}

final class ImageStoreService: ImageStoreServiceProtocol {
    
    func loadImage(key: String) -> Data? {
        if let dir = try? FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false),
           let data = try? Data(contentsOf: dir.appendingPathComponent(key)) {
            return data
        }
        return nil
    }
    
    func saveImage(key: String, imageData: Data) {
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false) as NSURL else {
            return
        }
        do {
            try imageData.write(to: directory.appendingPathComponent(key)!)
        } catch {
            print(error.localizedDescription)
        }
    }
}
