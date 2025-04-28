//
//  TagsModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//


// MARK: - TagsModel
struct TagsModel: Codable {
    let tags: [Tag]?
}

// MARK: - Tag
struct Tag: MyProductsProtocol, Codable {
    let id: Int?
    let name: String?
}
