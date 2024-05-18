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
    
    var userViewModel: UserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserProfileImageView()
        setupBindings()
    }
    
    @IBAction func getFollowers(_ sender: Any) {
        guard let user = self.userViewModel?.user else {
                print("User details not found.")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
            if let followersVC = storyboard.instantiateViewController(withIdentifier: "followersVC") as? FollowersVC {
                let viewModel = FollowersViewModel(userFollowersURL: user.followersUrl)
                followersVC.viewModel = viewModel
                self.navigationController?.pushViewController(followersVC, animated: true)
            } else {
                print("Could not instantiate FollowersVC")
            }
    }
    
    func configureUserProfileImageView() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
    }
    
    func setupBindings() {
        userViewModel?.userDataUpdated = { [weak self] in
            self?.updateUI()
        }
        userViewModel?.triggerInitialDataUpdate()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.usernameLabel.text = self.userViewModel?.userName
            self.userBioLabel.text = self.userViewModel?.userBio
            self.userNumberOfFollowersLabel.attributedText = self.userViewModel?.followersAttributedText
            
            if let imageUrl = self.userViewModel?.userAvatarURL {
                self.userProfileImageView.kf.setImage(with: imageUrl)
            } else {
                self.userProfileImageView.image = UIImage(systemName: "person.fill")
            }
        }
    }
}

