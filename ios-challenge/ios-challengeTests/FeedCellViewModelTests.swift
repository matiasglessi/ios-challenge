//
//  FeedCellViewModelTests.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 07/10/2020.
//

import XCTest
@testable import ios_challenge

class FeedCellViewModelTests: XCTestCase {
    
    private var viewModel: FeedCellViewModel!
    private let apiClient = APIClientMock()
    private let imageCache = ImageCacheMock()
    
    private let image = UIImage(systemName: "x.square.fill")!
    private let unknownError = APIClientError.unknown

    
    override func setUp() {
        viewModel = FeedCellViewModel(apiClient: apiClient, cache: imageCache)
    }
    
    func test_whenAskingForAnAlreadyCachedImage_thenReturnsCachedImage() {
        imageCache.saveImage(key: "123", image: image)
        
        viewModel.getThumbnail(with: "123") { [weak self] (result) in
            switch result {
            case .success (let image):
                XCTAssertEqual(image, self?.image)
            default:
                break
            }
        }
    }
    
    func test_whenAskingForANonValidThumbnailUrl_thenItReturnsFailure() {
        apiClient.imageResult = .failure(self.unknownError)
        
        viewModel.getThumbnail(with: "123") { [weak self] (result) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? APIClientError, self?.unknownError)
            default:
                break
            }
        }
    }
    
    
    
}
