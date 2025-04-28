//
//  MockProductAPI.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

@testable import MazaadyPortal

final class MockProductAPI: ProductAPIProtocol {

    var userResult: Result<UserModel?, Error>?
    var productsResult: Result<[ProductModel]?, Error>?
    var adsResult: Result<AdvertisementsModel?, Error>?
    var tagsResult: Result<TagsModel?, Error>?

    func getUserInformation(completion: @escaping (Result<UserModel?, Error>) -> Void) {
        if let result = userResult {
            completion(result)
        } else {
            completion(.failure(MockError.notImplemented))
        }
    }

    func getProducts(completion: @escaping (Result<[ProductModel]?, Error>) -> Void) {
        if let result = productsResult {
            completion(result)
        } else {
            completion(.failure(MockError.notImplemented))
        }
    }

    func getAdvertisements(completion: @escaping (Result<AdvertisementsModel?, Error>) -> Void) {
        if let result = adsResult {
            completion(result)
        } else {
            completion(.failure(MockError.notImplemented))
        }
    }

    func getTags(completion: @escaping (Result<TagsModel?, Error>) -> Void) {
        if let result = tagsResult {
            completion(result)
        } else {
            completion(.failure(MockError.notImplemented))
        }
    }
}

enum MockError: Error {
    case notImplemented
}
