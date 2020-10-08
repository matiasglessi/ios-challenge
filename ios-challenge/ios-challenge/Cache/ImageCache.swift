//
//  ImageCache.swift
//  ios-challenge
//
//  Created by Matias Glessi on 07/10/2020.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    func getImage(key: String) -> UIImage?
    func saveImage(key: String, image: UIImage)
}

final class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()
    
    lazy var cache = NSCache<NSString, UIImage>()

    func getImage(key: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: key)) {
            return image
        }
        return nil
    }

    func saveImage(key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }

}
