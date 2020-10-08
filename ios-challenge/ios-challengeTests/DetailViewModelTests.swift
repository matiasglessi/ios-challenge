//
//  DetailViewModelTests.swift
//  ios-challengeTests
//
//  Created by Matias Glessi on 08/10/2020.
//

import XCTest
@testable import ios_challenge


class DetailViewModelTests: XCTestCase {

    private var viewModel: DetailViewModel!
    private let apiClient = APIClientMock()
    private let post = PostMother().withTitle("Title").withThumbnail("thumbnail").get()
    private let thumbnailFailureImage = UIImage(systemName: "x.square.fill")!
    private let fakeThumbnailSuccessImage = UIImage(systemName: "infinity")!

    override func setUp() {
        viewModel = DetailViewModel(post: post, apiClient: apiClient)
    }
    
    func test_whenAskingForDetailInformationOnSuccess_thenItReturnsThubmnailAndTitle() {
        apiClient.imageResult = .success(fakeThumbnailSuccessImage)
        
        viewModel.getDetailInformation { [weak self] (title, image) in
            XCTAssertEqual(title, self?.post.title)
            XCTAssertEqual(image, self?.fakeThumbnailSuccessImage)

        }
    }
    
    func test_whenAskingForDetailInformationOnFailure_thenItReturnsFailureThubmnailAndTitle() {
        apiClient.imageResult = .failure(APIClientError.unknown)
        
        viewModel.getDetailInformation { [weak self] (title, image) in
            XCTAssertEqual(title, self?.post.title)
            XCTAssertEqual(image, self?.thumbnailFailureImage)

        }
    }
}
