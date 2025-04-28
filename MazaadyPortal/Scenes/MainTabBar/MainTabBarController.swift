//
//  MainTabBarController.swift
//  TON
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

class MainTabBarController: CustomTabBar {
    
    //MARK: - variables -
    
    weak var coordinator: HomeCoordinatorProtocol?
    private var tabBarCreatedBefore = false
    private var selectedTabBarIndex: Int
    
    //MARK: - life cycle -
    
    init(selectIndex: Int) {
        self.selectedTabBarIndex = selectIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycel -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        addCustomTabBarView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCustomTabBarFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        if !tabBarCreatedBefore {
            setupViewControllers()
            tabBarCreatedBefore = true
        }
    }
}

//MARK: - navigation controller -
extension MainTabBarController {
    private func setupNavigationController() {
        navigationItem.backButtonTitle = ""
    }
}

//MARK: - configration -
extension MainTabBarController {
    private func setupViewControllers() {
        viewControllers = [
            createViewController(for: coordinator?.getHomeViewController() ?? UIViewController(), image: SystemDesign.AppImages.home.image, title: AppLocalizedKeys.home.value),
            createViewController(for: coordinator?.getSearchViewController() ?? UIViewController(), image: SystemDesign.AppImages.searchBar.image, title: AppLocalizedKeys.search.value),
            createViewController(for: coordinator?.getSearchViewController() ?? UIViewController(), image: SystemDesign.AppImages.product.image.withRenderingMode(.alwaysOriginal), title: ""),
            createViewController(for: coordinator?.getCartViewController() ?? UIViewController(), image: SystemDesign.AppImages.cart.image, title: AppLocalizedKeys.cart.value),
            createViewController(for: coordinator?.getProfileViewController() ?? UIViewController(), image: SystemDesign.AppImages.profile.image, title: AppLocalizedKeys.profile.value)
        ]
        self.selectedIndex = selectedTabBarIndex
    }
}
//MARK: - did Select item -

extension MainTabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animationWhenSelectItem(item)
    }
}
