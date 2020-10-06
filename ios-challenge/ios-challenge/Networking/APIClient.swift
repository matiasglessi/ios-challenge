//
//  APIClient.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation

enum APIClientError: Error {
    case missingData
    case unknown
}

protocol APIClient {
    func performGETRequest(url: URL, completion: @escaping (Result<Data>) -> Void)
}

class URLSessionAPIClient: APIClient {
    
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func performGETRequest(url: URL, completion: @escaping (Result<Data>) -> Void) {
        session.loadData(from: url) { (data, error) in
            guard let data = data else {
                completion(.failure(APIClientError.missingData))
                return
            }
            
            if error != nil {
                completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
}


