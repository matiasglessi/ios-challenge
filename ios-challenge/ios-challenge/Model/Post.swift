//
//  Post.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation

enum ReadStatus: Equatable {
    case read
    case unread
}

struct Post: Equatable {
    let title: String
    let author: String
    let date: Date
    let thumbnailUrl: String
    let comments: Int
    let fullPictureUrl: String?
    var status: ReadStatus
    
    func getFormattedDate() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
