//
//  FollowersViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class FollowersViewModel {
    private let userFollowersURL: String
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    private var allFollowers: [Followers] = [] {
        didSet {
            filteredFollowers = allFollowers
        }
    }

    var filteredFollowers: [Followers] = [] {
        didSet {
            onUpdate?()
        }
    }

    init(userFollowersURL: String) {
        self.userFollowersURL = userFollowersURL
        fetchFollowers()
    }
    
    private func fetchFollowers() {
        Task {
            do {
                allFollowers = try await UserFollowersAPICaller.getFollowers(userFollowersURL: userFollowersURL)
            } catch {
                onError?("Failed to fetch followers.")
            }
        }
    }

    func filterFollowers(searchText: String) {
        if searchText.isEmpty {
            filteredFollowers = allFollowers
        } else {
            filteredFollowers = allFollowers.filter { $0.login.uppercased().contains(searchText.uppercased()) }
        }
    }
}
