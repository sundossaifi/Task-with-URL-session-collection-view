//
//  UserVC.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit
import Kingfisher

class UserVC: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var userNumberOfFollowersLabel: UILabel!
    @IBOutlet weak var getFollowersButtton: UIButton!
    
    var user: GitHubUser?
    let viewModel: FollowersViewModel = FollowersViewModel()
    
    @IBAction func getFollowers(_ sender: Any) {
        guard let user = self.user else {
            return
        }
        viewModel.getFollowers(userFollowersURL: user.followersUrl) {
            DispatchQueue.main.async {
                guard let followersVC = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as? FollowersVC else {
                    return
                }
                followersVC.followers = self.viewModel.followers
                self.navigationController?.pushViewController(followersVC, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        DispatchQueue.main.async {
            self.usernameLabel.text = self.user?.name
            self.userBioLabel.text = self.user?.bio
            if let user = self.user, let userName = user.name {
                let baseString = "\(userName) has \(user.followers) followers"
                let attributedString = NSMutableAttributedString(string: baseString)
                
                if let nameRange = baseString.range(of: userName) {
                    let nsRange = NSRange(nameRange, in: baseString)
                    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
                }
                
                let followersString = "\(user.followers)"
                if let followersRange = baseString.range(of: followersString) {
                    let nsRange = NSRange(followersRange, in: baseString)
                    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
                }

                self.userNumberOfFollowersLabel.attributedText = attributedString
            } else {
                self.userNumberOfFollowersLabel.text = "Data unavailable"
            }
            if let avatarURLString = self.user?.avatarUrl,
               let avatarURL = URL(string: avatarURLString) {
                self.userProfileImageView.kf.setImage(with: avatarURL)
            }
        }
    }
}
