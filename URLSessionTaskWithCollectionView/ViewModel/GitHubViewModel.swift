//
//  GitHubViewModel.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/15/24.
//

import UIKit

import UIKit

protocol GitHubViewModelDelegate: AnyObject {
    func didStartFetchingUser()
    func didEndFetchingUser()
    func didReceiveUser(user: GitHubUser?)
    func didFailWithError(message: String)
    func updateUsernameFieldWith(error: String)
}

class GitHubViewModel {
    weak var delegate: GitHubViewModelDelegate?
    var user: GitHubUser?

    func getUser(userName: String) {
        if validateUserName(userName) {
            delegate?.didStartFetchingUser()
            Task {
                do {
                    user = try await UserAPICaller.getUser(userName: userName)
                    delegate?.didReceiveUser(user: user)
                } catch GHError.invalidURL {
                    delegate?.didFailWithError(message: "Invalid URL")
                } catch GHError.invalidData {
                    delegate?.didFailWithError(message: "Invalid data")
                } catch GHError.invalidResponse {
                    delegate?.didFailWithError(message: "Invalid response")
                } catch {
                    delegate?.didFailWithError(message: "Unexpected error")
                }
                delegate?.didEndFetchingUser()
            }
        }
    }
    
    func validateUserName(_ userName: String) -> Bool {
        if userName.isEmpty {
            delegate?.updateUsernameFieldWith(error: "Please enter username")
            return false
        }
        return true
    }
}

