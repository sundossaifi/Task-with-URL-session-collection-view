//
//  GitHubUser.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/6/24.
//

import UIKit

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String?
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let name: String?
    let company: String?
    let blog: String
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String
    
    var fullAvatarURL: URL? {
        return URL(string: avatarUrl)
    }
}
