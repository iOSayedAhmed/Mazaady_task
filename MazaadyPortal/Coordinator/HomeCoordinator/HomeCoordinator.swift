//
//  HomeCoordinator.swift
//  TON
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

protocol HomeCoordinatorProtocol: UserHomeCoordinatorProtocol, AnyObject {
    func presentHomeCoordinator(selectedIndex: Int)
}

class HomeCoordinator: Coordinator, HomeCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var presentHomeClosure: ((Int) -> Void)?
    var selectedIndex: Int
    
    init(selectedIndex: Int, presentHomeClosure: ((Int) -> Void)?) {
        navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = UIColor.black
        self.selectedIndex = selectedIndex
        self.presentHomeClosure = presentHomeClosure
    }
    
    func start() {
       showMainTabBar(selectIndex: selectedIndex)
    }
}

// MARK: - main -

extension HomeCoordinator {
    func presentHomeCoordinator(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        presentHomeClosure?(selectedIndex)
    }
}

