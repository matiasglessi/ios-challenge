//
//  APIClientMock.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 06/10/2020.
//

import Foundation
import UIKit
@testable import ios_challenge

class APIClientMock: APIClient {
      
    var result: Result<PostsResult>?
    
    func performGETRequest(url: URL, completion: @escaping (Result<PostsResult>) -> Void) {
        completion(result!)
    }
    
    var imageResult: Result<UIImage>?
    
    func performDownloadRequest(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        completion(imageResult!)
    }
}
