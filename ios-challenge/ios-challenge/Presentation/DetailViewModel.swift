//
//  DetailViewModel.swift
//  ios-challenge
//
//  Created by Matias Glessi on 08/10/2020.
//

import Foundation
import UIKit

class DetailViewModel {
    
    let post: Post
    let cache: ImageCacheProtocol
    let apiClient: APIClient
    
    init(post: Post, cache: ImageCacheProtocol = ImageCache.shared, apiClient: APIClient) {
        self.post = post
        self.cache = cache
        self.apiClient = apiClient
    }
    
    func getDetailInformation(completion: @escaping (String, UIImage) -> Void) {
        
        let postTitle = post.title
        let postThumbnail = post.thumbnailUrl
        
        if let image = cache.getImage(key: post.thumbnailUrl) {
            completion(post.title, image)
        }
        else {
            apiClient.performDownloadRequest(url: URL(string: postThumbnail)!) { [weak self] (result) in
                switch result {
                case .success(let image):
                    self?.cache.saveImage(key: postThumbnail, image: image)
                    completion(postTitle, image)
                case .failure(_):
                    completion(postTitle, UIImage(systemName: "x.square.fill")!)
                }
            }
        }

    }
}
