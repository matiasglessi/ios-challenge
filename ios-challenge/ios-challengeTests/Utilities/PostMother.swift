//
//  PostMother.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation
@testable import ios_challenge

class PostMother {
    let title: String = ""
    let author: String = ""
    let date: Date = Date()
    let thumbnail: String = ""
    let comments: Int = 0
    let status: ReadStatus = .unread
    
    
    func get() -> Post {
        return Post(title: title, author: author, date: date, thumbnail: thumbnail, comments: comments, status: status)
    }
}
