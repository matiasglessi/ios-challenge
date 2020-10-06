//
//  PostMapperTests.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 06/10/2020.
//

import XCTest
@testable import ios_challenge

class PostMapperTests: XCTestCase {
    
    private var mapper: PostMapper!

    override func setUp() {
        mapper = PostMapper()
    }
    
    func test_whenAFullyFormatedJsonIsMapped_returnsAPost() {
        let json: [String : Any] = [
            "title" : "Title",
            "author": "Mr Author",
            "created": 0.0,
            "thumbnail": "http://fake.url.com",
            "num_comments": 0
        ]

        let post = mapper.jsonToPost(json: json)
        
        XCTAssertEqual(post.title, "Title")
    }
    
    
    
    func test_whenAJsonWithNoAuthorIsMapped_returnsAPost() {
        let json: [String : Any] = [
            "title" : "Title",
            "created": 0.0,
            "thumbnail": "http://fake.url.com",
            "num_comments": 0
        ]
        
        let post = mapper.jsonToPost(json: json)
        
        XCTAssertEqual(post.title, "Title")
        XCTAssertEqual(post.author, "")
    }
    
}
