//
//  DummyProfileCacheManager.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit
@testable import MazaadyPortal

class DummyProfileCacheManager: ProfileCacheManagerProtocol {
    var user: GenericCacheService<UserModel> {
        .init(fileName: "dummy_user.json")
    }
    var products: GenericCacheService<[ProductModel]> {
        .init(fileName: "dummy_products.json")
    }
    var ads: GenericCacheService<[Advertisement]> {
        .init(fileName: "dummy_ads.json")
    }
    var tags: GenericCacheService<[Tag]> {
        .init(fileName: "dummy_tags.json")
    }
}
