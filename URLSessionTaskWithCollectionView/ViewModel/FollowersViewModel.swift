//
//  FollowersViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class FollowersViewModel {
    var followers:[Followers]?
    
    init(followers: [Followers]? = nil) {
        self.followers = followers
    }
    
    func getFollowers(userFollowersURL: String, completion: @escaping () -> Void) {
        Task {
            do {
                followers = try await UserFollowersAPICaller.getFollowers(userFollowersURL: userFollowersURL)
                completion()
            } catch GHError.invalidURL {
                print("invalid URL")
                completion()
            } catch GHError.invalidData {
                print("invalid data")
                completion()
            } catch GHError.invalidResponse {
                print("invalid Response")
                completion()
            } catch {
                print("unexpected error")
                completion()
            }
        }
    }
}
