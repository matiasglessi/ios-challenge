//
//  SessionMock.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation
@testable import ios_challenge

class SessionMock: Session {
    var data: Data?
    var error: Error?

    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
}
