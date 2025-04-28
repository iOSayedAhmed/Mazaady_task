//
//  ProfileViewController.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var lanaguageButton: UIButton!
    @IBOutlet private weak var settingImageButton: UIButton!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    @IBOutlet private weak var followersCountLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var profileSegmentControl: UnderlineSegmentedControl!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var sendSearchImage: UIImageView!
    @IBOutlet private weak var emptyView: EmptyView!
    @IBOutlet private weak var productCollectionView: UICollectionView!
    @IBOutlet private weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topTagsStackView: UIStackView!
    @IBOutlet private weak var topTagLabel: UILabel!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    @IBOutlet private weak var tagsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let viewModel: ProfileViewModelType
    private let disposeBag = DisposeBag()
    private var currentSections: [ProductSectionModel] = []
    
    // MARK: - Initializer
    
    init( viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        productCollectionView.layoutIfNeeded()
        tagsCollectionView.layoutIfNeeded()
        
        productCollectionViewHeightConstraint.constant = productCollectionView.collectionViewLayout.collectionViewContentSize.height
        tagsCollectionViewHeightConstraint.constant = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

// MARK: - ViewModel Binding

private extension ProfileViewController {
    
    private func bindViewModel() {
        bindUserInfo()
        bindSections()
        viewModel.fetchProducts()
        viewModel.fetchAdvertisments()
        viewModel.fetchTags()
        bindSegmentControl()
        bindSearchTextField()
        lanaguageButtonTapped()
        settingImageButtonTapped()
        bindLoadingToViewModel()
        bindToErrorService()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true

        userImageView.applyCornerRadius(cornerRadius: 18)
        searchView.applyCornerRadius(cornerRadius: 10)
        
        sendSearchImage.image = SystemDesign.AppImages.send.image.imageFlippedForRightToLeftLayoutDirection()
        
        setupCollectionViews()
        setupSegmentControl()
        setupEmptyView()
        setTextLocalized()
    }

    private func bindUserInfo() {
        viewModel.profileImageURL
            .subscribe(onNext: { [weak self] imageUrl in
                self?.userImageView.setImage(url: URL(string: imageUrl))
            })
            .disposed(by: disposeBag)
        
        viewModel.displayName
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.username
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.followerCount
            .bind(to: followersCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.followingCount
            .bind(to: followingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userLocation
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func bindSections() {
        viewModel.combinedSections
            .bind(to: productCollectionView.rx.items(dataSource: collectionViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.combinedSections
            .observe(on: MainScheduler.instance)
            .bind { [weak self] sections in
                self?.currentSections = sections
                self?.productCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.productCollectionViewHeightConstraint.constant = self?.productCollectionView.collectionViewLayout.collectionViewContentSize.height ?? 0
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Add Lanaguage Tap

extension ProfileViewController {
    private func lanaguageButtonTapped() {
        lanaguageButton.setTitle(AppLocalizedKeys.currentLanguage.value, for: .normal)

        lanaguageButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getLanguageTapped()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Add Setting Tap

extension ProfileViewController {
    private func settingImageButtonTapped() {
        settingImageButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.didTapSettingButting()
            })
            .disposed(by: disposeBag)
    }

    @objc private func didTapSettingButting() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let currentStyle = window.overrideUserInterfaceStyle
        window.overrideUserInterfaceStyle = (currentStyle == .dark) ? .light : .dark
        
        print("Theme changed to: \(window.overrideUserInterfaceStyle == .dark ? "Dark Mode" : "Light Mode") ✅")
    }
}

//MARK: - bind Loading To view Model -

extension ProfileViewController {
    private func bindLoadingToViewModel() {
        viewModel.activityIndicatorStatus
            .subscribe(onNext: { [weak self] (isLoading) in
                guard let self = self else { return }
                Indicator.createIndicator(on: self, start: isLoading)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Bind to Error Service -

extension ProfileViewController {
    private func bindToErrorService() {
        viewModel.errorService
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                Alert.failedToConnectWithServerAlert(on: self)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup segment control

extension ProfileViewController {
    
    private func setupSegmentControl() {
        profileSegmentControl.setItems(items: [AppLocalizedKeys.products.value, AppLocalizedKeys.reviews.value, AppLocalizedKeys.followers.value])
        profileSegmentControl.selectedSegmentIndex = 0
    }
    
    private func bindSegmentControl() {
        profileSegmentControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.didSelectSegment(index: index)
                self?.handleSegmentSelection(index)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSegmentSelection(_ index: Int) {
        switch index {
        case 0:
            self.productCollectionView.isHidden = false
            self.topTagsStackView.isHidden = false
            self.emptyView.isHidden = true
            
        default:
            self.productCollectionView.isHidden = true
            self.topTagsStackView.isHidden = true
            self.emptyView.isHidden = false
        }
    }
}

// MARK: - Search View

extension ProfileViewController {
    private func bindSearchTextField() {
        searchTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchTextRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Empty View

extension ProfileViewController {
    private func setupEmptyView() {
        emptyView.configure(image: SystemDesign.AppImages.comingSoon.image, title: "",
                            description: "")
    }
}

// MARK: - CollectionView Setup

private extension ProfileViewController {
    
    func setupCollectionViews() {
        setupProductCollectionView()
        setupTagsCollectionView()
        registerCollectionViewCells()
        bindTagsCollectionView()
    }

    func setupProductCollectionView() {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.productSectionIndex = findProductSectionIndex()

        productCollectionView.collectionViewLayout = layout
        productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        productCollectionView.isScrollEnabled = false
    }

    func setupTagsCollectionView() {
        if let layout = tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 12
            layout.scrollDirection = .vertical
        }
        
        tagsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        tagsCollectionView.isScrollEnabled = false
    }

    func registerCollectionViewCells() {
        productCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        productCollectionView.register(AdvertisementsCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvertisementsCollectionViewCell.identifier)
        
        tagsCollectionView.register(TagsCollectionViewCell.nib(), forCellWithReuseIdentifier: TagsCollectionViewCell.identifier)
    }
    
    func bindTagsCollectionView() {
        viewModel.tagsObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tagsCollectionView.rx.items(
                cellIdentifier: TagsCollectionViewCell.identifier,
                cellType: TagsCollectionViewCell.self)
            ) { (row, model, cell) in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        viewModel.tagsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                guard let self = self, !tags.isEmpty else { return }
                let indexPath = IndexPath(item: 0, section: 0)
                self.tagsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            })
            .disposed(by: disposeBag)
    }

    func findProductSectionIndex() -> Int {
        return currentSections.firstIndex { $0.type == .product } ?? 0
    }
}

//MARK: - localized -

extension ProfileViewController {
    private func setTextLocalized() {
        followersLabel.text = AppLocalizedKeys.followers.value
        followingLabel.text = AppLocalizedKeys.following.value
        searchTextField.placeholder = AppLocalizedKeys.search.value
        topTagLabel.text = AppLocalizedKeys.topTags.value
    }
}

// MARK: - Layout Delegates

extension ProfileViewController: UICollectionViewDelegateFlowLayout, PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tagsCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: 50, height: 40)
            }
            let padding: CGFloat = 10
            let collectionViewWidth = collectionView.bounds.width - padding
            return CGSize(width: collectionViewWidth / 2, height: 40)
        }
        
        let section = currentSections[indexPath.section]
        let width = collectionView.bounds.width

        switch section.type {
        case .product:
            return productCellSize(for: section, at: indexPath, in: width)
        case .advertisement:
            return CGSize(width: width, height: 150)
        case .tag:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        heightForItemAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
        let section = currentSections[indexPath.section]

        switch section.type {
        case .product:
            return productCellHeight(for: section, at: indexPath)
        case .advertisement:
            return 150
        case .tag:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


// MARK: - Layout Helpers

private extension ProfileViewController {

    func productCellSize(for section: ProductSectionModel, at indexPath: IndexPath, in collectionWidth: CGFloat) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = floor((collectionWidth - totalSpacing) / itemsPerRow)

        // Safely guard index
        guard indexPath.item >= 0, indexPath.item < section.items.count,
              let product = section.items[indexPath.item] as? ProductModel else {
            return CGSize(width: itemWidth, height: 300)
        }

        let viewModel = ProductCellViewModel(product: product)
        var height: CGFloat = 120 + 45 + 16
        if viewModel.shouldShowOffer { height += 34 }
        if viewModel.shouldShowCountdown { height += 65 }

        return CGSize(width: itemWidth, height: height)
    }

    func productCellHeight(for section: ProductSectionModel, at indexPath: IndexPath) -> CGFloat {
        guard let product = section.items[indexPath.item] as? ProductModel else {
            return 300
        }

        let viewModel = ProductCellViewModel(product: product)
        var height: CGFloat = 120 + 45 + 16
        if viewModel.shouldShowOffer { height += 34 }
        if viewModel.shouldShowCountdown { height += 65 }

        return height
    }
}
