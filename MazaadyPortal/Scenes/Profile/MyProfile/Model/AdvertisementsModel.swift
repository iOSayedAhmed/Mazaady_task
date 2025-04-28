//
//  AdvertisementsModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//


// MARK: - AdvertisementsModel
struct AdvertisementsModel: Codable {
    let advertisements: [Advertisement]?
}

// MARK: - Advertisement
struct Advertisement: MyProductsProtocol, Codable {
    let id: Int?
    let image: String?
}
