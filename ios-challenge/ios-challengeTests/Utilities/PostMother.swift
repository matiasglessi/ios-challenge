//
//  PostMother.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation
@testable import ios_challenge

class PostMother {
    var title: String = ""
    var author: String = ""
    var date: Date = Date()
    var thumbnail: String = ""
    var comments: Int = 0
    var fullPictureUrl: String = ""
    var status: ReadStatus = .unread
    
    
    func get() -> Post {
        return Post(title: title, author: author, date: date, thumbnailUrl: thumbnail, comments: comments, fullPictureUrl: fullPictureUrl, status: status)
    }
    
    func withTitle(_ title: String) -> PostMother {
        self.title = title
        return self
    }
    
    func withThumbnail(_ thumbnail: String) -> PostMother {
        self.thumbnail = thumbnail
        return self
    }
    
    func withReadStatus(_ status: ReadStatus) -> PostMother {
        self.status = status
        return self
    }
}
