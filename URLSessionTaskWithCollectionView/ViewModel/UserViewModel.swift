//
//  UserViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class UserViewModel {
    var user: GitHubUser?
    
    init(user: GitHubUser? = nil) {
        self.user = user
    }
    
    func getUser(userName: String, completion: @escaping () -> Void) {
        Task{
            do {
                user = try await UserAPICaller.getUser(userName: userName)
                completion()
            } catch GHError.invalidURL {
                print("invalid URL")
            } catch GHError.invalidData {
                print("invalid data")
            } catch GHError.invalidResponse {
                print("invalid Response")
            } catch {
                print("unexpected error")
            }
        }
    }
}
