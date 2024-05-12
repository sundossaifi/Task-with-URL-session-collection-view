//
//  FollowerCollectionViewCell.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var followerProfileImageView: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
   private func configureView() {
        followerProfileImageView.layer.cornerRadius = followerProfileImageView.frame.height/2
    }
    
    func configureCell(follower: Followers) {
        self.followerProfileImageView.kf.setImage(with: follower.fullAvatarURL)
        self.followerName.text = follower.login
    }
}
