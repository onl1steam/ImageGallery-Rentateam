//
//  GalleryItem.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 12.02.2021.
//

import Foundation

struct GalleryItem: Codable {
    
    init(galleryResponse: GalleryResponse) {
        id = galleryResponse.id
        imageDescription = galleryResponse.imageDescription
        imageUrl = galleryResponse.urls.regular
        loadingDate = Date()
    }
    
    let id: String
    let imageDescription: String?
    let imageUrl: String
    let loadingDate: Date
}
