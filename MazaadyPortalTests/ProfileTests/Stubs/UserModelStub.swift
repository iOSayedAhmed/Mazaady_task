//
//  File.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 19/04/2025.
//

@testable import MazaadyPortal

extension UserModel {
    static func userModelMock() -> UserModel {
        return UserModel(id: 0, name: "Ali", image: "", userName: "iOSAYed", followingCount: 5, followersCount: 10, countryName: "Egypt", cityName: "Cairo")
    }
}
