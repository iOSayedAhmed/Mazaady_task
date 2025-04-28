//
//  PinterestLayoutDelegate.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//


import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class PinterestLayout: UICollectionViewLayout {

    weak var delegate: PinterestLayoutDelegate?

    var productSectionIndex: Int = 0
    private var numberOfColumns = 3
    private var cellPadding: CGFloat = 10

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var width: CGFloat {
        return collectionView?.bounds.width ?? 0
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }

        cache.removeAll()
        contentHeight = 0

        let numberOfSections = collectionView.numberOfSections
        let sectionInset: CGFloat = 10

        for section in 0..<numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)

            if section == productSectionIndex {
                // 📌 Pinterest grid logic
                let columnWidth = (width - CGFloat(numberOfColumns - 1) * cellPadding) / CGFloat(numberOfColumns)
                var xOffset = (0..<numberOfColumns).map { CGFloat($0) * (columnWidth + cellPadding) }
                var yOffset = Array(repeating: contentHeight, count: numberOfColumns)

                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath, with: columnWidth) ?? 180
                    let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0

                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: itemHeight)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    cache.append(attributes)

                    yOffset[column] += itemHeight + cellPadding
                }

                contentHeight = yOffset.max() ?? contentHeight

            } else {
                // 📌 Flow-style wrapping logic (tags/ads)
                var xOffset: CGFloat = sectionInset
                var yOffset: CGFloat = contentHeight
                var maxLineHeight: CGFloat = 0

                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let itemSize = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize(width: 100, height: 40)

                    // Wrap to next line if overflow
                    if xOffset + itemSize.width > width - sectionInset {
                        xOffset = sectionInset
                        yOffset += maxLineHeight + cellPadding
                        maxLineHeight = 0
                    }

                    let frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    cache.append(attributes)

                    xOffset += itemSize.width + cellPadding
                    maxLineHeight = max(maxLineHeight, itemSize.height)
                }

                yOffset += maxLineHeight + cellPadding
                contentHeight = yOffset
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
