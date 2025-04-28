//
//  UserModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let userName: String?
    let followingCount, followersCount: Int?
    let countryName, cityName: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case userName = "user_name"
        case followingCount = "following_count"
        case followersCount = "followers_count"
        case countryName = "country_name"
        case cityName = "city_name"
    }
}
