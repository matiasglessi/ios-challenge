//
//  APIClientTests.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 05/10/2020.
//

import XCTest
@testable import ios_challenge

class APIClientTests: XCTestCase {

    private var apiClient: URLSessionAPIClient!
    private var session = SessionMock()
  
    let fakeURL = URL(string: "http://fake.url.com")!
    let data = Data()
    let missingDataError = APIClientError.missingData
    let unknownError = APIClientError.unknown
    
    
    override func setUp() {
        apiClient = URLSessionAPIClient(session: session)
    }
    
    func test_whenSessionHasDataAndNoError_ThenDataIsRetrieved() {
        session.data = data
        
        apiClient.performGETRequest(url: fakeURL, completion: { (result) in
            
            switch result {
            case .success (let data):
                XCTAssertEqual(data, self.data)
            default:
                break
            }
        })
    }
    
    
    func test_whenSessionHasErrorAndNoData_ThenMissingDataErrorIsRetrieved() {
        apiClient.performGETRequest(url: fakeURL, completion: { (result) in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as! APIClientError, self.missingDataError)
            default:
                break
            }
        })
    }
    
    func test_whenSessionHasDataAndError_ThenAnErrorIsRetrieved() {
        session.error = unknownError
        session.data = data

        apiClient.performGETRequest(url: fakeURL, completion: { (result) in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as! APIClientError, self.unknownError)
            default:
                break
            }
        })
    }
}



