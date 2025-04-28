//
//  UIViewController+Animation.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation
import UIKit

//MARK: - dismiss view with animation -

extension UIViewController {
    public func dismissViewWithAnimation(view: UIView) {
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        }
        self.dismiss(animated: true)
    }
}

//MARK: - dismiss view when tapped around

extension UIViewController {
    public func dismissViewWhenTappedAround(subView: UIView) {
        addTapGestureToView(view: self.view, action: #selector(viewTapped))
        addTapGestureToView(view: subView, action: #selector(supViewTapped))
    }
    
    @objc private func viewTapped() {
        dismiss(animated: true)
    }
    @objc private func supViewTapped() {
        print(Self.self)
    }
}

//MARK: - for dismiss Keyboard when tapped In View

extension UIViewController{
    public func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - add Tap Gesture To View -

extension UIViewController {
    public func addTapGestureToView(view: UIView, action: Selector?) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
}
