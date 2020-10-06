//
//  Post.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation

enum ReadStatus {
    case read
    case unread
}

struct Post: Equatable {
    let title: String
    let author: String
    let date: Date
    let thumbnail: String
    let comments: Int
    let status: ReadStatus
}
    