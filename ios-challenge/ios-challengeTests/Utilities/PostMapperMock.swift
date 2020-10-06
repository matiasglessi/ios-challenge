//
//  PostMapperMock.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 06/10/2020.
//

import Foundation
@testable import ios_challenge

class PostMapperMock: Mapper {
    
    var post: Post?
    
    func jsonToPost(json: [String:Any]) -> Post {
        return post!
    }

}
