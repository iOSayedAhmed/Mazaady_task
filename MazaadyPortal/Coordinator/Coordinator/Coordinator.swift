//
//  Coordinator.swift
//  TON
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {
    func show(viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    func presentViewController(viewController: UIViewController, animated: Bool = true) {
        navigationController.present(viewController, animated: animated)
    }
    
    func presentCoordinator(coordinator: Coordinator, animated: Bool = true, completion: @escaping () -> Void = {}) {
        navigationController.present(coordinator.navigationController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: @escaping () -> Void = {}) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}
