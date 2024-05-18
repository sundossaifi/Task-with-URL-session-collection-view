//
//  UserViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class UserViewModel {
    var user: GitHubUser? {
        didSet {
            userDataUpdated?()
        }
    }
    var userDataUpdated: (() -> Void)?
    
    var userName: String? {
        return user?.name ?? "No name available"
    }
    
    var userBio: String? {
        return user?.bio ?? "No bio provided"
    }
    
    var followersAttributedText: NSAttributedString? {
        guard let user = user else {
            return NSAttributedString(string: "Followers: Unavailable")
        }
        let followersCount = user.followers
        let baseString = "\(user.name ?? "The user") has \(followersCount) followers"
        let attributedString = NSMutableAttributedString(string: baseString)
        let followersString = "\(followersCount)"
        if let followersRange = baseString.range(of: followersString) {
            let nsRange = NSRange(followersRange, in: baseString)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
        }
        return attributedString
    }
    
    var userAvatarURL: URL? {
        return user?.fullAvatarURL
    }
    
    init(user: GitHubUser?) {
        self.user = user
    }
    
    func triggerInitialDataUpdate() {
        userDataUpdated?()
    }
}
