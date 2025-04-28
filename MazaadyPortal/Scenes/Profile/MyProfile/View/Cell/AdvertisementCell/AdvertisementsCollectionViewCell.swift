//
//  AdvertisementsCollectionViewCell.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

final class AdvertisementsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var adsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(with model: Advertisement) {
        if let urlString = model.image {
            adsImageView.setImage(url: URL(string: urlString))
        }
    }

    private func setupUI() {
        subView.applyCornerRadius(cornerRadius: 20)
        adsImageView.applyCornerRadius(cornerRadius: 20)
    }
}

//MARK: - Cell Identifier -

extension AdvertisementsCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "AdvertisementsCollectionViewCell", bundle: nil)
    }
    static let identifier = "AdvertisementsCollectionViewCell"
}
