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
        configureSubmitUserButton(isEnabled: true)
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
                self.usernameTextField.layer.borderColor = UIColor.systemGray5.cgColor
                self.usernameTextField.layer.borderWidth = 1.0
                self.usernameTextField.attributedPlaceholder = NSAttributedString(
                    string: "Set Username",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
                self.loadingUserIndicator.isHidden = false
                self.loadingUserIndicator.startAnimating()
                self.configureSubmitUserButton(isEnabled: false)
                self.viewModel.getUser(userName: userName) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.loadingUserIndicator.isHidden = true
                        self.loadingUserIndicator.stopAnimating()
                        self.configureSubmitUserButton(isEnabled: true)
                        guard let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVC") as? UserVC else {
                            return
                        }
                        userVC.user = self.viewModel.user
                        self.usernameTextField.text = ""
                        self.navigationController?.pushViewController(userVC, animated: true)
                    }
                }
            }
        }
    }
    
    func configureUsernameTextField() {
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        usernameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.masksToBounds = true
        usernameTextField.addPadding()
    }
    
    func configureSubmitUserButton(isEnabled: Bool) {
        submitUserButton.isEnabled = isEnabled
        submitUserButton.layer.cornerRadius = 5
        submitUserButton.backgroundColor = .darkGray
        let color = isEnabled ? UIColor.white : UIColor.white
        submitUserButton.setTitleColor(color, for: .normal)
        submitUserButton.setTitleColor(color, for: .disabled)
    }
}
