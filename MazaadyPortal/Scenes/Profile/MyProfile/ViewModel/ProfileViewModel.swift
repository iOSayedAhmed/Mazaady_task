//
//  ProfileViewModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileViewModelType: AnyObject {
    var displayName: Observable<String> { get }
    var username: Observable<String> { get }
    var profileImageURL: Observable<String> { get }
    var followerCount: Observable<String> { get }
    var followingCount: Observable<String> { get }
    var userLocation: Observable<String> { get }
    
    var tagsObservable: Observable<[Tag]> { get }
    
    var searchTextRelay: BehaviorRelay<String> { get }
    
    var activityIndicatorStatus: BehaviorRelay<Bool> { get }
    var errorService: PublishSubject<Error> { get }
    
    var selectedProfileTabsSegment: BehaviorRelay<ProfileViewModel.MyProfileSegment> { get }
    
    var combinedSections: Observable<[ProductSectionModel]> { get }

    func fetchData()
    func fetchProducts()
    func fetchAdvertisments()
    func fetchTags()
    func didSelectSegment(index: Int)
    
    func getLanguageTapped()
}

class ProfileViewModel: ProfileViewModelType {
    
    enum MyProfileSegment: Int {
        case products, reviews, followers
    }
    
    // MARK: - Dependencies
    private let api: ProductAPIProtocol
    private var coordinator: HomeCoordinatorProtocol
    private let cache: ProfileCacheManagerProtocol
    
    // MARK: - Observables
    var displayNameRelay = BehaviorRelay<String>(value: "")
    var displayName: Observable<String> { displayNameRelay.asObservable() }
    
    var usernameRelay = BehaviorRelay<String>(value: "")
    var username: Observable<String> { usernameRelay.asObservable() }

    var profileImageURLRelay = BehaviorRelay<String>(value: "")
    var profileImageURL: Observable<String> { profileImageURLRelay.asObservable() }

    var followerCountRelay = BehaviorRelay<String>(value: "")
    var followerCount: Observable<String> { followerCountRelay.asObservable() }

    var followingCountRelay = BehaviorRelay<String>(value: "")
    var followingCount: Observable<String> { followingCountRelay.asObservable() }

    var userLocationRelay = BehaviorRelay<String>(value: "")
    var userLocation: Observable<String> { userLocationRelay.asObservable() }
    
    let searchTextRelay = BehaviorRelay<String>(value: "")
    
    private let productsRelay = BehaviorRelay<[ProductModel]>(value: [])
    var products: Observable<[ProductModel]> { productsRelay.asObservable() }
    
    private let tagsRelay = BehaviorRelay<[Tag]>(value: [])
    var tagsObservable: Observable<[Tag]> { tagsRelay.asObservable() }
    
    private let advertisementsRelay = BehaviorRelay<[Advertisement]>(value: [])
    var advertisementsObservable: Observable<[Advertisement]> { advertisementsRelay.asObservable() }
    
    var combinedSectionsRelay = BehaviorRelay<[ProductSectionModel]>(value: [])
    var combinedSections: Observable<[ProductSectionModel]> {
        combinedSectionsRelay.asObservable()
    }
    
    var selectedProfileTabsSegment = BehaviorRelay<MyProfileSegment>(value: .products)

    let activityIndicatorStatus = BehaviorRelay<Bool>(value: false)
    let errorService = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(coordinator: HomeCoordinatorProtocol, api: ProductAPIProtocol = ProductAPI(), dependencies: ProfileViewModelDependencies = ProfileViewModelDependencies()) {
        self.api = api
        self.coordinator = coordinator
        self.cache = dependencies.cache
        fetchData()
    }
    
    func fetchData() {
        fetchUserInformation()
        bindSections()
        bindSelectedProfileTabsSegment()
    }
    
    private func bindSelectedProfileTabsSegment() {
        switch selectedProfileTabsSegment.value {
        case.products:
            fetchProducts()
            fetchAdvertisments()
            fetchTags()
        case .reviews:
            return
        case .followers:
            return
        }
    }
    
    func didSelectSegment(index: Int) {
        selectedProfileTabsSegment.accept(MyProfileSegment(rawValue: index) ?? .products)
    }
}

// MARK: - Fetch User Information -

extension ProfileViewModel {
    private func fetchUserInformation() {
        activityIndicatorStatus.accept(true)

        api.getUserInformation { [weak self] result in
            guard let self else { return }
            self.activityIndicatorStatus.accept(false)

            switch result {
            case .success(let user):
                if let user {
                    self.bindUserProfileData(from: user)
                    self.cache.user.save(user)
                }
            case .failure(let error):
                if let cached = self.cache.user.load() {
                    self.bindUserProfileData(from: cached)
                } else {
                    self.errorService.onNext(error)
                }
            }
        }
    }
    
    private func bindUserProfileData(from user: UserModel?) {
        displayNameRelay.accept(user?.name ?? "")
        usernameRelay.accept("@\(user?.userName ?? "")")
        profileImageURLRelay.accept(user?.image ?? "")
        followerCountRelay.accept("\(user?.followersCount ?? 0)")
        followingCountRelay.accept("\(user?.followingCount ?? 0)")
        userLocationRelay.accept("\(user?.countryName ?? ""), \(user?.cityName ?? "")")
    }
}

// MARK: - Fetch Products

extension ProfileViewModel {
    func fetchProducts() {
        activityIndicatorStatus.accept(true)

        api.getProducts { [weak self] result in
            guard let self else { return }
            self.activityIndicatorStatus.accept(false)

            switch result {
            case .success(let products):
                if let products {
                    productsRelay.accept(products)
                    self.cache.products.save(products)
                }
            case .failure(let error):
                let cached = self.cache.products.load() ?? []
                productsRelay.accept(cached)
                self.errorService.onNext(error)
            }
        }
    }
}

// MARK: - Fetch Ads

extension ProfileViewModel {
    func fetchAdvertisments() {
        activityIndicatorStatus.accept(true)

        api.getAdvertisements { [weak self] result in
            guard let self else { return }
            self.activityIndicatorStatus.accept(false)

            switch result {
            case .success(let ads):
                if let ads = ads?.advertisements {
                    advertisementsRelay.accept(ads)
                    self.cache.ads.save(ads)
                }
            case .failure(let error):
                let cached = self.cache.ads.load() ?? []
                advertisementsRelay.accept(cached)
                self.errorService.onNext(error)
            }
        }
    }
}

// MARK: - Fetch Tags

extension ProfileViewModel {
    func fetchTags() {
        activityIndicatorStatus.accept(true)

        api.getTags { [weak self] result in
            guard let self else { return }
            self.activityIndicatorStatus.accept(false)

            switch result {
            case .success(let tags):
                if let tags = tags?.tags {
                    let allTags = [Tag(id: 0, name: "All")] + tags
                    tagsRelay.accept(allTags)
                    self.cache.tags.save(allTags)
                }
            case .failure(let error):
                let cached = self.cache.tags.load() ?? []
                tagsRelay.accept(cached)
                self.errorService.onNext(error)
            }
        }
    }
}

// MARK: -

extension ProfileViewModel {
    private func bindSections() {
        Observable.combineLatest(productsRelay, advertisementsRelay, tagsRelay, searchTextRelay)
            .map { products, ads, tags, searchText in
                let filteredProducts: [ProductModel]
                if searchText.isEmpty {
                    filteredProducts = products
                } else {
                    filteredProducts = products.filter {
                        $0.name?.lowercased().contains(searchText.lowercased()) == true
                    }
                }
                
                let productSection = ProductSectionModel.profileSection(title: "", items: filteredProducts)
                let adsSection = ProductSectionModel.profileSection(title: "", items: ads)
                return [productSection, adsSection]
            }
            .bind(to: combinedSectionsRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: - Choosse lnangaue Tapped

extension ProfileViewModel {
    func getLanguageTapped() {
        coordinator.getChooesLanguageViewController()
    }
}
