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
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPosts(completion: @escaping (Error?) -> Void) {
        apiClient.performGETRequest(url: URL(string: "https://www.reddit.com/top/.json?limit=50")!) { [weak self] (result) in
            switch result {
            case .success(let posts):
                self?.posts = posts
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
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
}
