//
//  ImageService.swift
//  ImageGallery-Rentateam
//
//  Created by Рыжков Артем on 11.02.2021.
//

import Foundation

protocol ImageServiceProtocol {
    func fetchImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?
}

final class ImageService: ImageServiceProtocol {
    
    // MARK: - Public properties
    
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    // MARK: - ImageServiceProtocol Realization
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
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
        return dataTask
    }
}
