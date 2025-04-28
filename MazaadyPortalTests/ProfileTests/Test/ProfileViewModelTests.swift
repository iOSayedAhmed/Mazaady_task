//
//  ProfileViewModelTests.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//


import XCTest
import RxSwift
import RxCocoa
@testable import MazaadyPortal

final class ProfileViewModelTests: XCTestCase {

    private var viewModel: ProfileViewModelType!
    private var mockAPI: MockProductAPI!
    private var mockCoordinator: MockHomeCoordinator!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockAPI = MockProductAPI()
        mockCoordinator = MockHomeCoordinator()
        disposeBag = DisposeBag()

        // Use a dummy cache manager that does nothing
        let dummyCacheManager = DummyProfileCacheManager()
        let dependencies = ProfileViewModelDependencies(api: mockAPI, cache: dummyCacheManager)
        viewModel = ProfileViewModel(coordinator: mockCoordinator, api: mockAPI, dependencies: dependencies)
    }

    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        mockCoordinator = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchUserInformation_success_emitsUsername() {
        let user = UserModel.userModelMock()
        mockAPI.userResult = .success(user)
        
        let usernameExpectation = expectation(description: "Username updated")

        viewModel.username
            .skip(1)
            .subscribe(onNext: { username in
                XCTAssertEqual(username, "@iOSAYed")
                usernameExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchData()

        wait(for: [usernameExpectation], timeout: 0.1)
    }
    
    func testFetchUserInformation_failure_usesCache() {
        mockAPI.userResult = .failure(MockError.notImplemented)

        let nameExpectation = expectation(description: "Fallback to cached name")

        viewModel.displayName
            .skip(1)
            .subscribe(onNext: { name in
                XCTAssertEqual(name, "Ali")
                nameExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.fetchData()

        wait(for: [nameExpectation], timeout: 0.2)
    }
    
    func testFetchUserInformation_success_emitsDisplayName() {
        let user = UserModel.userModelMock()
        mockAPI.userResult = .success(user)
        
        let displayNameExpectation = expectation(description: "Display name updated")
        
        viewModel.displayName
            .skip(1)
            .subscribe(onNext: { name in
                XCTAssertEqual(name, "Ali")
                displayNameExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchData()

        wait(for: [displayNameExpectation], timeout: 0.1)
    }
    
    func testFetchUserInformation_success_emitsFollowerCount() {
        let user = UserModel.userModelMock()
        mockAPI.userResult = .success(user)
        
        let displayFollowerCount = expectation(description: "Display Follower Count")

        viewModel.followerCount
            .skip(1)
            .subscribe(onNext: { followerCount in
                XCTAssertEqual(followerCount, "10")
                displayFollowerCount.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchData()

        wait(for: [displayFollowerCount], timeout: 0.1)
    }
    
    func testFetchUserInformation_success_emitsFollowingCount() {
        let user = UserModel.userModelMock()
        mockAPI.userResult = .success(user)
        
        let displayFollowingCount = expectation(description: "Display Following Count")

        viewModel.followingCount
            .skip(1)
            .subscribe(onNext: { followingCount in
                XCTAssertEqual(followingCount, "5")
                displayFollowingCount.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchData()

        wait(for: [displayFollowingCount], timeout: 0.1)
    }
    
    func testSearchTextFiltering_filtersProductsCorrectly() {
        // Given
        let mockProduct = ProductModel(id: 1, name: "MacBook", image: "", price: 1200, currency: "USD", offer: 0, endDate: 0)
        mockAPI.productsResult = .success([mockProduct])
        viewModel.fetchProducts()

        let expectation = self.expectation(description: "Product filtered by search")

        viewModel.combinedSections
            .skip(1)
            .subscribe(onNext: { sections in
                let filtered = sections.first?.items.compactMap { $0 as? ProductModel }
                XCTAssertEqual(filtered?.first?.name, "MacBook")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        viewModel.searchTextRelay.accept("mac")

        wait(for: [expectation], timeout: 0.2)
    }
    
    func testFetchUserInfo_failure_emitsError() {
        // Given
        mockAPI.userResult = .failure(MockError.notImplemented)

        let errorExpectation = expectation(description: "Error emitted")

        viewModel.errorService
            .take(1)
            .subscribe(onNext: { error in
                XCTAssertEqual(error as? MockError, .notImplemented)
                errorExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        viewModel.fetchData()

        wait(for: [errorExpectation], timeout: 0.2)
    }

    func testSegmentChange_toProducts_callsFetchProductsAndAdsAndTags() {
        // Given
        mockAPI.productsResult = .success([
            ProductModel(id: 1, name: "Item", image: "", price: 10, currency: "USD", offer: 0, endDate: 0)
        ])
        mockAPI.adsResult = .success(AdvertisementsModel(advertisements: []))
        mockAPI.tagsResult = .success(TagsModel(tags: []))

        let expectation = self.expectation(description: "Data Fetched After Segment Change")

        viewModel.combinedSections
            .skip(1)
            .take(1) // ✅ only respond to the first value
            .subscribe(onNext: { sections in
                let productSectionItems = sections.first?.items
                XCTAssertEqual(productSectionItems?.count, 1)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Activate bindings
        viewModel.fetchData()

        // When
        viewModel.didSelectSegment(index: 0) // .products

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testDidSelectSegment_updatesSelectedSegment() {
        viewModel.didSelectSegment(index: 2)
        XCTAssertEqual(viewModel.selectedProfileTabsSegment.value, .followers)
    }

    func testGetLanguageTapped_callsCoordinator() {
        viewModel.getLanguageTapped()
        XCTAssertTrue(mockCoordinator.didCallGetLanguageVC)
    }
}
