//
//  File.swift
//  
//
//  Created by Zahgloul on 11/05/2023.
//

import UIKit

//MARK: - apply shadow for view -

extension UIView {
    func applyCornerRadius(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
    }
}

//MARK: - apply border for view -

extension UIView {
    func applyBorder(borderColor: UIColor = SystemDesign.AppColors.primary.color, borderWidth: CGFloat = 1) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = 8.0
    }
}

//MARK: - make view is circle -

extension UIView {
    func makeCircleView() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}

// MARK: - Apply Masks Corners -

extension UIView {
    func applyCornersRadius(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
    }
}

// MARK: - Apply Masks Corners -

extension UIView {
    func applyMaskCornersUp(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension UIView {
    @discardableResult   
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(to: self)
        return contentView
    }
    
    func layoutAttachAll(to : UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: to.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: to.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: to.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: to.bottomAnchor).isActive = true
    }
}
