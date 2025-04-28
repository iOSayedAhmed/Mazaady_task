//
//  ProfileCacheManager.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

final class ProfileCacheManager: ProfileCacheManagerProtocol {
    let user = GenericCacheService<UserModel>(fileName: "cached_user.json")
    let products = GenericCacheService<[ProductModel]>(fileName: "cached_products.json")
    let ads = GenericCacheService<[Advertisement]>(fileName: "cached_ads.json")
    let tags = GenericCacheService<[Tag]>(fileName: "cached_tags.json")
}
