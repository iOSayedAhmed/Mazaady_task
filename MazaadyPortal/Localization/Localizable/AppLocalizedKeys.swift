//
//  AppLocalizedKeys.swift
//  TON-Driver
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

// MARK: - app Localized keys

enum AppLocalizedKeys: String {
    
    // MARK: - Tabbar cases
    case home
    case search
    case cart
    case profile
    
    // MARK: - Profile Page cases
    case following
    case followers
    case products
    case reviews
    case price
    case lotStarts
    case offerPrice
    case topTags
    case language
    case currentLanguage
    case english
    case arabic
    
    var value: String {
        return self.rawValue.localized
    }
}
