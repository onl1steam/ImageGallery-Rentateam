//
//  GalleryService.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

protocol GalleryServiceProtocol {
    func fetchGallery(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class GalleryService: GalleryServiceProtocol {
    
    // MARK: - Public properties
    
    let session = URLSession(configuration: .ephemeral)
    var dataTask: URLSessionDataTask?
    
    // MARK: - GalleryServiceProtocol Realization
    
    func fetchGallery(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
        dataTask?.resume()
    }
}
