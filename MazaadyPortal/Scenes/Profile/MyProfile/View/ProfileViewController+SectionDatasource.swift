//
//  PermitSectionModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import RxDataSources
import UIKit

extension ProfileViewController {
    func collectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<ProductSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<ProductSectionModel>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }

                switch self.viewModel.selectedProfileTabsSegment.value {
                case .products:
                    if let productModel = item as? ProductModel {
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ProductCollectionViewCell.identifier,
                            for: indexPath
                        ) as? ProductCollectionViewCell else {
                            return UICollectionViewCell()
                        }

                        let viewModel = ProductCellViewModel(product: productModel)
                        cell.configure(with: viewModel)
                        return cell

                    } else if let adsModel = item as? Advertisement {
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: AdvertisementsCollectionViewCell.identifier,
                            for: indexPath
                        ) as? AdvertisementsCollectionViewCell else {
                            return UICollectionViewCell()
                        }

                        cell.configure(with: adsModel)
                        return cell

                    } else {
                        return collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath)
                    }

                case .reviews, .followers:
                    return UICollectionViewCell()
                }
            }
        )
    }
}

// MARK: - Data Source Model

enum ProductSectionModel {
    case profileSection(title: String, items: [MyProductsProtocol])
}

extension ProductSectionModel: SectionModelType {
    typealias Item = MyProductsProtocol
    
    var items: [MyProductsProtocol] {
        switch  self {
        case .profileSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: ProductSectionModel, items: [Item]) {
        switch original {
        case let .profileSection(title: title, items: _):
            self = .profileSection(title: title, items: items)
        }
    }
}

extension ProductSectionModel {
    var title: String {
        switch self {
        case .profileSection(title: let title, items: _):
            return title
        }
    }
}

enum SectionContentType {
    case product, advertisement, tag
}

extension ProductSectionModel {
    var type: SectionContentType {
        guard let firstItem = items.first else { return .product }
        if firstItem is ProductModel {
            return .product
        } else if firstItem is Advertisement {
            return .advertisement
        } else if firstItem is Tag {
            return .tag
        }
        return .product
    }
}
