//
//  APICaller.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

enum GitHubAPIConstants {
    static let baseURL = "https://api.github.com/users/"
}

enum GitHubAPI {
    case user(String)

    var url: URL? {
        switch self {
        case .user(let userName):
            return URL(string: GitHubAPIConstants.baseURL + userName)
        }
    }
}

public class UserAPICaller {
    static func getUser(userName: String) async throws -> GitHubUser {
        guard let url = GitHubAPI.user(userName).url else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}
