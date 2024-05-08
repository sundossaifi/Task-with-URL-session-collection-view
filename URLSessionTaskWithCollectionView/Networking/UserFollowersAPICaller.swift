//
//  UserFollowersAPICaller.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/7/24.
//

import UIKit

class UserFollowersAPICaller {
    static func getFollowers(userFollowersURL: String) async throws -> [Followers] {
        guard let url = URL(string: userFollowersURL) else {
            throw GHError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Followers].self, from: data)
        } catch {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            print("Failed to decode. Received JSON: \(json)")
                        }
            throw GHError.invalidData
        }
    }
}
