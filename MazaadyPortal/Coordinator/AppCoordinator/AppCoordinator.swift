//
//  AppCoordinator.swift
//  TON
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

class AppCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        presentHomeCoordinator(selectedIndex: 4)
    }
}

//MARK: - present home coordinator -

extension AppCoordinator {
     func presentHomeCoordinator(selectedIndex: Int) {
        let homeCoordinator = HomeCoordinator(selectedIndex: selectedIndex, presentHomeClosure: { [weak self] selectedIndex in
            guard let self = self else { return }
            self.childCoordinators.removeAll()
            self.presentHomeCoordinator(selectedIndex: selectedIndex)
        })
        
        startCoordinator(homeCoordinator)
        replaceWindowRootViewController(homeCoordinator.navigationController)
    }
}

// MARK: - start coordinator -
//
private extension AppCoordinator {
    private func startCoordinator(_ coordinator: Coordinator) {
        childCoordinators = [coordinator]
        coordinator.start()
    }
}

// MARK: replace root view controller Window
//
private extension AppCoordinator {
    func replaceWindowRootViewController(_ viewController: UIViewController) {
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.window.rootViewController = viewController
            self.window.makeKeyAndVisible()
        }, completion: { _ in
            // maybe do something on completion here
        })
    }
}
