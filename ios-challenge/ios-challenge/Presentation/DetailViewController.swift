//
//  DetailViewController.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!

    var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getDetailInformation(completion: { [weak self] (title, image) in
            self?.updateDetailInformation(with: title, and: image)
        })
    }
    
    private func updateDetailInformation(with title: String, and image: UIImage) {
        DispatchQueue.main.async {
            self.postImageView.image = image
            self.postDescriptionLabel.text = title
        }
    }
}
