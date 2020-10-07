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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.readIndicatorView.round()
    }
    
    func configure(for post: Post?) {
        
        guard let post = post else { return }
        
        self.titleLabel.text = post.title
        self.authorLabel.text = post.author
        self.commentsLabel.text = "\(String(describing: post.comments)) comments"
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
