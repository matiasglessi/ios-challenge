//
//  Session.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation

protocol Session {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }

        task.resume()
    }
}
