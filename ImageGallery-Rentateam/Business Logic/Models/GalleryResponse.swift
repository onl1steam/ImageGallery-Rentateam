//
//  GalleryResponse.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

struct GalleryResponse: Codable {
    let id: String
    let imageDescription: String?
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id, urls
        case imageDescription = "alt_description"
    }
}

struct Urls: Codable {
    let regular: String
}
