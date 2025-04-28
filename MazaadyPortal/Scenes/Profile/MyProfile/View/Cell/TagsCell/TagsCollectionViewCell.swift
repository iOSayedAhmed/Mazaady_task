//
//  TagsCollectionViewCell.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

final class TagsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var tagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        // Measure width only
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: 40)
        var size = contentView.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .fittingSizeLevel,
                                                       verticalFittingPriority: .required)

        let horizontalPadding: CGFloat = 4
        size.width += horizontalPadding
        size.height = 40

        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame

        return layoutAttributes
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                subView.backgroundColor = SystemDesign.AppColors.hueOrange.color
                subView.applyBorder(borderColor: SystemDesign.AppColors.orange.color)
                tagNameLabel.textColor = SystemDesign.AppColors.orange.color
            } else {
                subView.backgroundColor = SystemDesign.AppColors.whiteBlack.color
                subView.applyBorder(borderColor: SystemDesign.AppColors.grayG5.color)
                tagNameLabel.textColor = SystemDesign.AppColors.grayG5.color
            }
        }
    }
    
    func configure(with model: Tag) {
        tagNameLabel.text = model.name
    }
    
    private func setupUI() {
        subView.applyBorder(borderColor: SystemDesign.AppColors.grayG5.color)
        tagNameLabel.textColor = SystemDesign.AppColors.grayG5.color
    }
}

//MARK: - Cell Identifier -

extension TagsCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "TagsCollectionViewCell", bundle: nil)
    }
    static let identifier = "TagsCollectionViewCell"
}
