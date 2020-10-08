//
//  FeedViewModel.swift
//  ios-challenge
//
//  Created by Matias Glessi on 06/10/2020.
//

import Foundation

class FeedViewModel {
    
    private let apiClient: APIClient
    private var posts = [Post]()
    
    private let pageSize = 10
    private let offset = 3
    private var currentPage = 1
    private var maxPostsAvailable = 50
    
    private var after = ""
    
    weak var delegate: FeedViewModelDelegate?
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPosts(completion: @escaping (Error?) -> Void) {
        
        let urlString = getRedditUrl(limit: pageSize, after: after)
        
        apiClient.performGETRequest(url: URL(string: urlString)!) { [weak self] (result) in
            switch result {
            case .success(let postResult):
                self?.posts = postResult.posts
                self?.after = postResult.afterValue
                self?.updatePaginationValues()
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func updatePaginationValues() {
        currentPage = 1
    }
    
    func getPostForNewCell(at index: Int) -> Post? {
        
        if shouldFetchMorePosts(index: index) {
            fetchMorePosts()
        }
        
        return isValidIndex(index: index) ?
            posts[index] :
            nil
    }
    
    
    private func shouldFetchMorePosts(index: Int) -> Bool {
        return index == pageSize * currentPage - offset

    }
    
    fileprivate func isMaxPostsAvailableReached() -> Bool {
        return self.getPostsCount() == maxPostsAvailable
    }
    
    private func fetchMorePosts() {
        
        if isMaxPostsAvailableReached() { return }
        
        let limit = calculateNewLimit()
        let urlString = getRedditUrl(limit: limit, after: after)
        
        apiClient.performGETRequest(url: URL(string: urlString)!) { [weak self] (result) in
            switch result {
            case .success(let postResult):
                self?.posts += postResult.posts
                self?.after = postResult.afterValue
                self?.currentPage += 1
                self?.delegate?.newPostsAdded()
            default:
                break
            }
        }
    }
    
    private func calculateNewLimit() -> Int {
        let totalPostsCount = self.getPostsCount()
        
        if totalPostsCount + pageSize <= 50 {
            return pageSize
        }
        return maxPostsAvailable - totalPostsCount
    }
    
    
    func getPost(at index: Int) -> Post? {
        return isValidIndex(index: index) ?
            posts[index] :
            nil
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    private func isValidIndex(index: Int) -> Bool {
        return posts.count > index
    }
    
    func removePost(at location: Int) {
        posts.remove(at: location)
    }
    
    func removeAllPosts() {
        posts.removeAll()
    }
    
    func markAsRead(at index: Int) {
        if isValidIndex(index: index) {
            posts[index].status = .read
        }
    }
    
    private func getRedditUrl(limit: Int, after: String) -> String {
        return "https://www.reddit.com/top/.json?limit=\(limit)&after=\(after)"
    }
}

protocol FeedViewModelDelegate: class {
    func newPostsAdded()
}
