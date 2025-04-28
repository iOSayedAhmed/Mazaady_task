//
//  ProductModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

protocol MyProductsProtocol: Codable {}

// MARK: - ProductModel
struct ProductModel: MyProductsProtocol, Codable {
    let id: Int?
    let name: String?
    let image: String?
    let price: Int?
    let currency: String?
    let offer: Int?
    let endDate: Double?
}

extension ProductModel {
    enum CodingKeys: String, CodingKey {
        case id, name, image, price, currency, offer
        case endDate = "end_date"
    }
}
