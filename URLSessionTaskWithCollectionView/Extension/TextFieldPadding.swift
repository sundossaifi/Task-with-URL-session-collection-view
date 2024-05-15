//
//  TextFieldPadding.swift
//  URLSessionTaskWithCollectionView
//
//  Created by User on 5/15/24.
//

import UIKit

extension UITextField {
    func addPadding() {
        let paddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
