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
        addSaveToGalleryGestureRecognizer()
    }
    
    private func addSaveToGalleryGestureRecognizer() {
        let tapToSaveToGalleryGesture = UITapGestureRecognizer(target: self, action: #selector(saveToGallery));
        postImageView.addGestureRecognizer(tapToSaveToGalleryGesture)
    }
    
    @objc func saveToGallery() {
        viewModel?.getPostImage(completion: { [weak self] (image) in
            self?.saveImageToGallery(image: image)
        })
    }

    private func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Error!", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved!", message: "Image has been saved to Gallery.")
        }
    }
    
    private func showAlert(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func updateDetailInformation(with title: String, and image: UIImage) {
        DispatchQueue.main.async {
            self.postImageView.image = image
            self.postDescriptionLabel.text = title
        }
    }
}
