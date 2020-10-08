//
//  FeedCellViewModel.swift
//  ios-challenge
//
//  Created by Matias Glessi on 07/10/2020.
//

import Foundation
import UIKit

class FeedCellViewModel {
    
    let apiClient: APIClient
    let cache: ImageCacheProtocol
    
    init(apiClient: APIClient, cache: ImageCacheProtocol = ImageCache.shared) {
        self.apiClient = apiClient
        self.cache = cache
    }
    
    func getThumbnail(with url: String, completion: @escaping (Result<UIImage>) -> Void) {
        
        if let image = cache.getImage(key: url) {
            completion(.success(image))
        }
        else {
            apiClient.performDownloadRequest(url: URL(string: url)!) { [weak self] (result) in
                switch result {
                case .success(let image):
                    self?.cache.saveImage(key: url, image: image)
                    completion(result)
                case .failure(_):
                    completion(result)
                }
            }
        }
    }
}
