//
//  PostMapper.swift
//  ios-challenge
//
//  Created by Matias Glessi on 06/10/2020.
//

import Foundation

protocol Mapper {
    func jsonToPost(json: [String:Any]) -> Post
}

class PostMapper: Mapper {
    
    func jsonToPost(json: [String : Any]) -> Post {
        let title = getString(from: json["title"])
        let author = getString(from: json["author"])
        let date = getDate(from: json["created"])
        let thumbnail = getString(from: json["thumbnail"])
        let fullPictureUrl = getString(from: json["url_overridden_by_dest"])
        let comments = getInt(from: json["num_comments"])
        
        return Post(title: title, author: author, date: date, thumbnailUrl: thumbnail, comments: comments, fullPictureUrl: fullPictureUrl, status: .unread)
        
    }
    
    private func getString(from json: Any?) -> String {
        return json as? String ?? ""
    }
    
    private func getDate(from json: Any?) -> Date {
        guard let value = json as? Double else {
            return Date()
        }
        return Date(timeIntervalSince1970: value)
    }
    
    private func getInt(from json: Any?) -> Int {
        return json as? Int ?? 0
    }
    
}

