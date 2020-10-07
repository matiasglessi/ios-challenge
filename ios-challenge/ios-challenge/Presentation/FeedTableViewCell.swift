//
//  FeedTableViewCell.swift
//  ios-challenge
//
//  Created by Matias Glessi on 06/10/2020.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var readIndicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var feedCellViewModel: FeedCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.feedCellViewModel = FeedCellViewModel(apiClient: URLSessionAPIClient(mapper: PostMapper()))
        self.readIndicatorView.round()
    }
    
    func configure(for post: Post?) {
        
        guard let post = post else { return }
        
        self.titleLabel.text = post.title
        self.authorLabel.attributedText = getAuthorAndDateText(for: post)
        self.commentsLabel.text = "\(String(describing: post.comments)) comments"
        self.configurePostThumbnail(for: post.thumbnail)
    }
    
    
    private func configurePostThumbnail(for thumbnail: String) {
        feedCellViewModel.downloadThumbnail(with: thumbnail) { [weak self] (result) in
            self?.updateThumbnailWith(result: result)
        }
    }
    
    private func updateThumbnailWith(result: Result<UIImage>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let image):
                self.thumbnailImageView.image = image
            case .failure(_):
                self.thumbnailImageView.image = UIImage.init(systemName: "x.square.fill")
            }
        }
    }
    
    private func getAuthorAndDateText(for post: Post) -> NSAttributedString {
        let date = post.getFormattedDate()
        let author = post.author
        
        let message = author + " " + date
        
        
        let authorAndDateAttributedString =
            NSMutableAttributedString(string: message,
                                      attributes: [
                                        .font: UIFont.systemFont(ofSize: 16.0),
                                        .foregroundColor: UIColor.white
                                      ])
        authorAndDateAttributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 13.0),
                .foregroundColor: UIColor.lightGray
            ], range: NSRange((message.range(of: date)!), in: message))
        return authorAndDateAttributedString
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

private extension UIView {
    func round(){
        self.layer.cornerRadius = self.frame.size.width/2
         self.clipsToBounds = true
    }
}
