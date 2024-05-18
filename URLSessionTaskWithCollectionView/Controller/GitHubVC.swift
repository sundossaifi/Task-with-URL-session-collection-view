//
//  GitHubVC.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit
import Toast

class GitHubVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loadingUserIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitUserButton: UIButton!
    
    let viewModel = GitHubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureUsernameTextField()
        configureSubmitUserButton(isEnabled: true)
        loadingUserIndicator.isHidden = true
    }
    
    @IBAction func submitUsername(_ sender: Any) {
        guard let userName = usernameTextField.text else { return }
        viewModel.getUser(userName: userName)
    }
    
    func configureUsernameTextField() {
        usernameTextField.addPadding()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height / 2
        usernameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.masksToBounds = true
    }
    
    func configureSubmitUserButton(isEnabled: Bool) {
        submitUserButton.isEnabled = isEnabled
        submitUserButton.layer.cornerRadius = 5
        submitUserButton.backgroundColor = .darkGray
        submitUserButton.setTitleColor(isEnabled ? UIColor.white : UIColor.gray, for: .normal)
    }
}

extension GitHubVC: GitHubViewModelDelegate {
    func didStartFetchingUser() {
        DispatchQueue.main.async {
            self.loadingUserIndicator.isHidden = false
            self.loadingUserIndicator.startAnimating()
            self.configureSubmitUserButton(isEnabled: false)
        }
    }
    
    func didEndFetchingUser() {
        DispatchQueue.main.async {
            self.loadingUserIndicator.isHidden = true
            self.loadingUserIndicator.stopAnimating()
            self.configureSubmitUserButton(isEnabled: true)
        }
    }
    
    func didReceiveUser(user: GitHubUser?) {
        DispatchQueue.main.async {
            self.navigateToUserViewController(with: user)
        }
    }
    
    func didFailWithError(message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message)
        }
    }
    
    func updateUsernameFieldWith(error: String) {
        DispatchQueue.main.async {
            self.usernameTextField.addPadding()
            self.usernameTextField.layer.borderColor = UIColor.red.cgColor
            self.usernameTextField.attributedPlaceholder = NSAttributedString(
                string: error,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
        }
    }
    
    private func navigateToUserViewController(with user: GitHubUser?) {
        guard let userVC = storyboard?.instantiateViewController(withIdentifier: "UserVC") as? UserVC,
              let user = user else { return }

        let userViewModel = UserViewModel(user: user)
        userVC.userViewModel = userViewModel
        let navController = UINavigationController(rootViewController: userVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
