//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

protocol ProductAPIProtocol {
    func getUserInformation(completion: @escaping (Result<UserModel?, Error>) -> Void)
    func getAdvertisements(completion: @escaping (Result<AdvertisementsModel?, Error>) -> Void)
    func getTags(completion: @escaping (Result<TagsModel?, Error>) -> Void)
    func getProducts(completion: @escaping (Result<[ProductModel]?, Error>) -> Void)
}

class ProductAPI: BaseAPI<ProductTarget>, ProductAPIProtocol {
    
    override init() {}
}

// MARK: - Get Tags -

extension ProductAPI {
    func getUserInformation(completion: @escaping (Result<UserModel?, Error>) -> Void) {
        connectWithServer(target: .getUserInfromation) { result in
            completion(result)
        }
    }
}

// MARK: - Get Tags -

extension ProductAPI {
    func getAdvertisements(completion: @escaping (Result<AdvertisementsModel?, Error>) -> Void) {
        connectWithServer(target: .getAdvertisements) { result in
            completion(result)
        }
    }
}

// MARK: - Get Tags -

extension ProductAPI {
    func getTags(completion: @escaping (Result<TagsModel?, Error>) -> Void) {
        connectWithServer(target: .getTags) { result in
            completion(result)
        }
    }
}

// MARK: - Get Product -

extension ProductAPI {
    func getProducts(completion: @escaping (Result<[ProductModel]?, Error>) -> Void) {
        connectWithServer(target: .getProducts) { result in
            completion(result)
        }
    }
}
