//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

open class CustomTabBar: UITabBarController {
    
    //MARK: - variables -
    //
    private var customTabBarView = UIView(frame: .zero)
    
}

// MARK: - UI methods -
//
extension CustomTabBar {
    public func setupCustomTabBarFrame() {
        let height = self.view.safeAreaInsets.bottom + 64
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        customTabBarView.frame = tabBar.frame
    }
    
    public func setupTabBarUI() {
        // Setup your colors and corner radius
        self.tabBar.backgroundColor = SystemDesign.AppColors.tabBar.color
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.backgroundColor = SystemDesign.AppColors.tabBar.color
        self.tabBar.tintColor = SystemDesign.AppColors.primary.color
        self.tabBar.unselectedItemTintColor = SystemDesign.AppColors.primary.color
        
        // Remove the line
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
    
    public func addCustomTabBarView() {
        self.customTabBarView.frame = tabBar.frame
        
        self.customTabBarView.backgroundColor = .yellow
        self.customTabBarView.layer.cornerRadius = 30
        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.customTabBarView.layer.masksToBounds = false
        self.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.customTabBarView.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.customTabBarView.layer.shadowOpacity = 0.5
        self.customTabBarView.layer.shadowRadius = 20
        
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
}

//MARK: - create view controllers -
//
extension CustomTabBar {
    public func createViewController(for viewController: UIViewController,
                                     image: UIImage, title: String) -> UIViewController {
        viewController.tabBarItem.image = image
        viewController.title = title
        return viewController
    }
}

//MARK: - animation when selected item -
//
extension CustomTabBar {
    public func animationWhenSelectItem(_ item: UITabBarItem){
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.5
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}
