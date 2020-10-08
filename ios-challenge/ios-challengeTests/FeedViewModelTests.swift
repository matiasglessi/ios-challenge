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
    
    
    func test_whenAPostIsRemoveAtIndex_thenThePostIsRemovedFromViewModel(){
        apiClient.result = .success([post, post])
        
        viewModel.getPosts { [weak self] (error) in
            self?.viewModel.removePost(at: 0)
            XCTAssertEqual(self?.viewModel.getPost(at: 1), nil)
            XCTAssertEqual(self?.viewModel.getPostsCount(), 1)
        }
    }
    
    func test_whenAllPostsAreRemoved_thenThePostsAreRemovedFromViewModel(){
        apiClient.result = .success([post, post])
        
        viewModel.getPosts { [weak self] (error) in
            self?.viewModel.removeAllPosts()
            XCTAssertEqual(self?.viewModel.getPost(at: 1), nil)
            XCTAssertEqual(self?.viewModel.getPost(at: 0), nil)
            XCTAssertEqual(self?.viewModel.getPostsCount(), 0)
        }
    }
    
    
    func test_whenMarkingAsReadAnUnreadPost_thenThePostIsMarkedAsRead(){
        let unreadPost = PostMother()
            .withReadStatus(.unread)
            .get()

        apiClient.result = .success([unreadPost])
        
        viewModel.getPosts { [weak self] (error) in
            self?.viewModel.markAsRead(at: 0)
            XCTAssertEqual(self?.viewModel.getPost(at: 0)?.status, .read)
        }
    }
    
    
    func test_whenMarkingAsReadAReadPost_thenThePostIsStillMarkedAsRead(){
        let unreadPost = PostMother()
            .withReadStatus(.read)
            .get()

        apiClient.result = .success([unreadPost])
        viewModel.getPosts { [weak self] (error) in
            self?.viewModel.markAsRead(at: 0)
            XCTAssertEqual(self?.viewModel.getPost(at: 0)?.status, .read)
        }
    }
}

