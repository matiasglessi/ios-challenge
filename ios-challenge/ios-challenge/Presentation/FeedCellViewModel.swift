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
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func downloadThumbnail(with url: String, completion: @escaping (Result<UIImage>) -> Void) {        
        apiClient.performDownloadRequest(url: URL(string: url)!, completion: completion)
    }

}
