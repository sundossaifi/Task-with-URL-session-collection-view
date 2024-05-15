//
//  FollowersVC.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit

class FollowersVC: UIViewController {

    @IBOutlet weak var followersCollectionView: UICollectionView!
    @IBOutlet weak var searchFollowersBar: UISearchBar!
    
    var followers: [Followers]?
    var filteredFollowers: [Followers]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        followersCollectionView.dataSource = self
        followersCollectionView.delegate = self
        followersCollectionView.register(FollowerCollectionViewCell.nib(), forCellWithReuseIdentifier: FollowerCollectionViewCell.identifier)
        
        searchFollowersBar.delegate = self
        
        filteredFollowers = followers
        
        navigationController?.navigationBar.tintColor = .black
    }
}

extension FollowersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let filteredFollowers = filteredFollowers else {
            return 0
        }
       return filteredFollowers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = followersCollectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.identifier, for: indexPath) as! FollowerCollectionViewCell
        if let filteredFollowers = filteredFollowers {
            cell.configureCell(follower: filteredFollowers[indexPath.row])
        }
        return cell
    }
}

extension FollowersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let followers = followers else {
            return
        }
        if !searchText.isEmpty {
            filteredFollowers = followers.filter { $0.login.uppercased().contains(searchText.uppercased()) }
        } else {
            filteredFollowers = followers
        }
        followersCollectionView.reloadData()
    }
}

extension FollowersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = followersCollectionView.frame.width
        let cellWidth = (collectionViewWidth - 50) / 4
        let cellHeight = cellWidth + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
