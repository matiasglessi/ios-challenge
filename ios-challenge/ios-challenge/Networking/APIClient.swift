//
//  APIClient.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation
import UIKit

struct PostsResult: Equatable {
    let posts: [Post]
    let afterValue: String
}

enum APIClientError: Error, Equatable {
    case missingData
    case unknown
}

protocol APIClient {
    func performGETRequest(url: URL, completion: @escaping (Result<PostsResult>) -> Void)
    func performDownloadRequest(url: URL, completion: @escaping (Result<UIImage>) -> Void)
}

class URLSessionAPIClient: APIClient {
    
    private let session: Session
    private let mapper: Mapper
    
    init(session: Session = URLSession.shared, mapper: Mapper) {
        self.session = session
        self.mapper = mapper
    }
    
    func performGETRequest(url: URL, completion: @escaping (Result<PostsResult>) -> Void) {
        session.loadData(from: url) { (data, _, error) in
            guard let data = data else {
                completion(.failure(APIClientError.missingData))
                return
            }
            
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let jsonData = convertedJsonIntoDict["data"] as? [String : Any],
                       let afterValue = jsonData["after"] as? String,
                       let jsonArray = jsonData["children"] as? [[String : Any]] {

                        var posts = [Post]()
                        jsonArray.forEach { (json) in
                            if let postData = json["data"] as? [String:Any] {
                                posts.append(self.mapper.jsonToPost(json: postData))
                            }
                        }
                        completion(.success(PostsResult(posts: posts, afterValue: afterValue)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func performDownloadRequest(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        
        session.loadData(from: url) { (data, response, error) in
            guard
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                completion(.failure(APIClientError.unknown))
                return
            }
            
            completion(.success(image))
        }
        
    }
}





