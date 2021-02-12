//
//  GalleryService.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

protocol GalleryServiceProtocol {
    func fetchGallery(page: Int, imagesPerPage: Int, completion: @escaping (Result<Data, Error>) -> Void)
}

final class GalleryService: GalleryServiceProtocol {
    
    // MARK: - Public properties
    
    let session = URLSession(configuration: .ephemeral)
    var dataTask: URLSessionDataTask?
    
    // MARK: - GalleryServiceProtocol Realization
    
    func fetchGallery(page: Int, imagesPerPage: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = makeUrl(page: page, imagesPerPage: imagesPerPage) else { return }
        print(url.absoluteString)
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
    
    private func makeUrl(page: Int, imagesPerPage: Int) -> URL? {
        let token = APISettings.apiKey
        var components = URLComponents()
        components.scheme = APISettings.scheme
        components.host = APISettings.host
        components.path = APISettings.path
        components.queryItems = [
            URLQueryItem(name: "client_id", value: token),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(imagesPerPage)")
        ]
        return components.url
    }
}
