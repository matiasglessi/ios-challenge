//
//  FeedViewModelTests.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 06/10/2020.
//

import XCTest
@testable import ios_challenge

class FeedViewModelTests: XCTestCase {

    private var viewModel: FeedViewModel!
    private let apiClient = APIClientMock()
    private let post = PostMother().get()
    
    override func setUp() {
        viewModel = FeedViewModel(apiClient: apiClient)
    }
    
    func test_whenResultIsSuccessWithPosts_thenTheViewModelRetrievesPostCount() {
        apiClient.result = .success([post])
        
        viewModel.getPosts { [weak self] (error) in
            XCTAssert(self?.viewModel?.getPostsCount() == 1)
        }
    }
    
    func test_whenResultIsSuccessWithPosts_thenTheViewModelRetrievesPost() {
        apiClient.result = .success([post])
        
        viewModel.getPosts { [weak self] (error) in
            XCTAssertEqual(self?.viewModel?.getPost(at: 0), self?.post)
        }
    }
    
    func test_whenResultIsFailure_thenTheViewModelRetrievesNothing() {
        apiClient.result = .failure(APIClientError.unknown)
        
        viewModel.getPosts { [weak self] (error) in
            XCTAssert(self?.viewModel?.getPostsCount() == 0)
        }
    }
    
    func test_whenIndexIsInvalid_thenTheViewModelReturnNil() {
        apiClient.result = .success([post])
        
        viewModel.getPosts { [weak self] (error) in
            XCTAssertEqual(self?.viewModel?.getPost(at: 1), nil)
        }
    }
    
    func test_whenRepositoryIsEmpty_thenTheViewModelReturnNil() {
        apiClient.result = .success([])
        
        viewModel.getPosts { [weak self] (error) in
            XCTAssertEqual(self?.viewModel?.getPost(at: 1), nil)
        }
    }    
}

