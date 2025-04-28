//
//  CacheServiceProtocol.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

protocol CacheServiceProtocol {
    associatedtype T: Codable
    func save(_ object: T)
    func load() -> T?
    func clear()
}

