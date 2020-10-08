//
//  ImageCacheMock.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 07/10/2020.
//

import Foundation
import UIKit
@testable import ios_challenge

class ImageCacheMock: ImageCacheProtocol {
    
    private var cache: [String : UIImage] = [:]
    
    func getImage(key: String) -> UIImage? {
        return cache[key]
    }
    
    func saveImage(key: String, image: UIImage) {
        cache[key] = image
    }
}
