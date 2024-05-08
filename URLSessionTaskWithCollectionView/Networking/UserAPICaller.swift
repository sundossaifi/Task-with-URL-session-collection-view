//
//  APICaller.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

public class UserAPICaller {
    static func getUser(userName: String) async throws -> GitHubUser {
        let endPoint = "https://api.github.com/users/\(userName)"
        guard let url = URL(string: endPoint) else {
            throw GHError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
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
