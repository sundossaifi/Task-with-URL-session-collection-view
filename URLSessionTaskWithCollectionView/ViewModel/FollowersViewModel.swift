//
//  FollowersViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class FollowersViewModel {
    private let userFollowersURL: String
    private var currentPage = 1
    private var isLoading = false
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
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let newFollowers = try await UserFollowersAPICaller.getFollowers(userFollowersURL: userFollowersURL, page: currentPage)
                allFollowers += newFollowers
                if !newFollowers.isEmpty {
                    currentPage += 1
                }
                isLoading = false
            } catch {
                onError?("Failed to fetch followers: \(error)")
                isLoading = false
            }
        }
    }
    
    func fetchNextPage() {
        fetchFollowers()
    }

    func filterFollowers(searchText: String) {
        if searchText.isEmpty {
            filteredFollowers = allFollowers
        } else {
            filteredFollowers = allFollowers.filter { $0.login.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    func getFollowersCount() -> Int {
        return allFollowers.count
    }
}
