//
//  ProfileViewModelDependencies.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

struct ProfileViewModelDependencies {
    let api: ProductAPIProtocol
    let cache: ProfileCacheManagerProtocol

    init(api: ProductAPIProtocol = ProductAPI(), cache: ProfileCacheManagerProtocol = ProfileCacheManager()) {
        self.api = api
        self.cache = cache
    }
}
