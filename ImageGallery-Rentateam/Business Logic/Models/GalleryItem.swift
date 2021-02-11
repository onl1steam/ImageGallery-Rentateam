//
//  GalleryItem.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

struct GalleryItem: Codable {
    let id: String
    let imageDescription: String
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id, urls
        case imageDescription = "alt_description"
    }
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
