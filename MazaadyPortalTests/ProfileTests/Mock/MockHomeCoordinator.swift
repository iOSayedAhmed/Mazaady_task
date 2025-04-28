//
//  MockHomeCoordinator.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit
@testable import MazaadyPortal

final class MockHomeCoordinator: HomeCoordinatorProtocol {

    // For HomeCoordinatorProtocol
    var didPresentHomeCoordinator: Bool = false
    var presentedIndex: Int?

    func presentHomeCoordinator(selectedIndex: Int) {
        didPresentHomeCoordinator = true
        presentedIndex = selectedIndex
    }

    // For UserHomeCoordinatorProtocol
    var didCallGetLanguageVC = false

    func showMainTabBar(selectIndex: Int) {
        // Stub: Do nothing
    }

    func getHomeViewController() -> UIViewController {
        return UIViewController()
    }

    func getSearchViewController() -> UIViewController {
        return UIViewController()
    }

    func getCartViewController() -> UIViewController {
        return UIViewController()
    }

    func getProfileViewController() -> UIViewController {
        return UIViewController()
    }

    func getChooesLanguageViewController() {
        didCallGetLanguageVC = true
    }
}
