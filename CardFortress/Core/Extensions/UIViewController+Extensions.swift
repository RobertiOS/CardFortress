//
//  UIViewController+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/17/23.
//

import UIKit
import SnackBar


class CFSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = CFColors.purple.color
        style.textColor = .white
        return style
    }
}


extension UIViewController {
    func presentSnackbar(with message: String) {
        CFSnackBar.make(in: self.view, message: message, duration: .lengthShort).show()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
