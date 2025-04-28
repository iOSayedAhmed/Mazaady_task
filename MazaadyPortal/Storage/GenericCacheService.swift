//
//  GenericCacheService.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

final class GenericCacheService<T: Codable>: CacheServiceProtocol {
    private let fileName: String
    private var fileURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }

    init(fileName: String) {
        self.fileName = fileName
    }

    func save(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
        } catch {
            print("❌ Save cache failed:", error)
        }
    }

    func load() -> T? {
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
