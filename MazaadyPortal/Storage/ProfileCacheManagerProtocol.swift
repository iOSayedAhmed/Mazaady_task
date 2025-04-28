//
//  ProfileCacheManagerProtocol.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

protocol ProfileCacheManagerProtocol {
    var user: GenericCacheService<UserModel> { get }
    var products: GenericCacheService<[ProductModel]> { get }
    var ads: GenericCacheService<[Advertisement]> { get }
    var tags: GenericCacheService<[Tag]> { get }
}
