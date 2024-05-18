//
//  UserFollowersAPICaller.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class UserFollowersAPICaller {
    static func getFollowers(userFollowersURL: String, page: Int) async throws -> [Followers] {
        let urlString = "\(userFollowersURL)?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Followers].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}
