//
//  GitHubVC.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/5/24.
//

import UIKit

class GitHubVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loadingUserIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitUserButton: UIButton!
    
    let viewModel: UserViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUsernameTextField()
        loadingUserIndicator.isHidden = true
    }
    
    @IBAction func submitUsername(_ sender: Any) {
        DispatchQueue.main.async {
            guard let userName = self.usernameTextField.text  else{
                return
            }
            if userName.isEmpty {
                self.usernameTextField.layer.borderColor = UIColor.red.cgColor
                self.usernameTextField.layer.borderWidth = 1.0
                self.usernameTextField.attributedPlaceholder = NSAttributedString(
                    string: "Please enter username",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            } else {
                self.usernameTextField.layer.borderColor = UIColor.black.cgColor
                self.usernameTextField.layer.borderWidth = 1.0
                self.usernameTextField.attributedPlaceholder = NSAttributedString(
                    string: "Please enter username",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
                self.loadingUserIndicator.isHidden = false
                self.loadingUserIndicator.startAnimating()
                self.submitUserButton.isEnabled = false
                self.viewModel.getUser(userName: userName) {
                    DispatchQueue.main.async {
                        self.loadingUserIndicator.isHidden = true
                        self.loadingUserIndicator.stopAnimating()
                        self.submitUserButton.isEnabled = true
                        guard let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVC") as? UserVC else {
                            return
                        }
                        userVC.user = self.viewModel.user
                        self.usernameTextField.text = ""
                        self.navigationController?.pushViewController(userVC, animated: true)
                    }
                }
//                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
//                    
//                }
            }
        }
    }
    
    func configureUsernameTextField() {
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.masksToBounds = true
    }
}
