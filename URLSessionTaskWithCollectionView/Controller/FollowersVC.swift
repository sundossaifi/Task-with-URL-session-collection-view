//
//  FollowersVC.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit
import Toast

class FollowersVC: UIViewController {

    @IBOutlet weak var followersCollectionView: UICollectionView!
    @IBOutlet weak var searchFollowersBar: UISearchBar!
    
    var viewModel: FollowersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.followersCollectionView.reloadData()
            }
        }
        viewModel?.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.view.makeToast(error)
            }
        }
    }
    
    
    
    func configureCollectionView() {
        followersCollectionView.dataSource = self
        followersCollectionView.delegate = self
        followersCollectionView.register(FollowerCollectionViewCell.nib(), forCellWithReuseIdentifier: FollowerCollectionViewCell.identifier)
            
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureSearchBar() {
            searchFollowersBar.delegate = self
        }
}

extension FollowersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.filteredFollowers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.identifier, for: indexPath) as? FollowerCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of ColorsListCell.")
        }
        if let follower = viewModel?.filteredFollowers[indexPath.row] {
            cell.configureCell(follower: follower)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = viewModel?.getFollowersCount() else { return  }
        if indexPath.item == count-1 {
            viewModel?.fetchNextPage()
        }
    }
}

extension FollowersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterFollowers(searchText: searchText)
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
