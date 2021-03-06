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
    private let session = SessionMock()
    private let mapper = PostMapperMock()
  
    private let fakeURL = URL(string: "http://fake.url.com")!
    private let post = PostMother().get()
    private let missingDataError = APIClientError.missingData
    private let unknownError = APIClientError.unknown
    private let image = UIImage(systemName: "x.square.fill")
    
    override func setUp() {
        apiClient = URLSessionAPIClient(session: session, mapper: mapper)
    }
    
    func test_whenSessionHasDataAndNoError_ThenThePostsAreRetrieved() {
        session.data = Data()
        mapper.post = post
        
        apiClient.performGETRequest(url: fakeURL, completion: { (result) in
            
            switch result {
            case .success (let postResult):
                XCTAssertEqual(postResult, PostsResult(posts: [self.post], afterValue: ""))
            default:
                break
            }
        })
    }
    
    
    func test_whenSessionHasDataAndNoError_ThenTheImageIsRetrieved() {
        session.data = image?.pngData()
        apiClient.performDownloadRequest(url: fakeURL) { (result) in
            switch result {
            case .success (let image):
                XCTAssertEqual(image, self.image)
            default:
                break
            }
        }
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
}



