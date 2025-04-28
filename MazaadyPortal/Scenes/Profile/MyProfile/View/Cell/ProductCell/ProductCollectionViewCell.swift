//
//  ProductCollectionViewCell.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceValueLabel: UILabel!
    @IBOutlet private weak var offerPriceStackView: UIStackView!
    @IBOutlet private weak var offerPriceLabel: UILabel!
    @IBOutlet private weak var offerPriceValueLabel: UILabel!
    @IBOutlet private weak var oldPriceLabel: UILabel!
    @IBOutlet private weak var endDateStackView: UIStackView!
    @IBOutlet private weak var lotStartLabel: UILabel!
    @IBOutlet private weak var endDateDayView: UIView!
    @IBOutlet private weak var endDateDayLabel: UILabel!
    @IBOutlet private weak var endDateHourView: UIView!
    @IBOutlet private weak var endDateHourLabel: UILabel!
    @IBOutlet private weak var endDateMinuteView: UIView!
    @IBOutlet private weak var endDateMinuteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setTextLocalized()
    }
    
    func configure(with model: ProductCellViewModel) {
        productNameLabel.text = model.name
        priceValueLabel.text = model.priceText
        offerPriceValueLabel.text = model.offerText
        oldPriceLabel.setStrikethroughText(model.priceText)

        // Load image
        if let urlString = model.imageURL {
            productImageView.setImage(url: URL(string: urlString))
        }

        // End date labels
        endDateDayLabel.text = model.days
        endDateHourLabel.text = model.hours
        endDateMinuteLabel.text = model.minutes

        // Visibility handling
        offerPriceStackView.isHidden = !model.shouldShowOffer
        endDateStackView.isHidden = !model.shouldShowCountdown
    }
    
    private func setupUI() {
        subView.applyCornerRadius(cornerRadius: 24)
        productImageView.applyCornerRadius(cornerRadius: 24)
        endDateDayView.applyCornerRadius(cornerRadius: 14)
        endDateHourView.applyCornerRadius(cornerRadius: 14)
        endDateMinuteView.applyCornerRadius(cornerRadius: 14)
    }
    
    private func setTextLocalized() {
        priceLabel.text = AppLocalizedKeys.price.value
        offerPriceLabel.text = AppLocalizedKeys.offerPrice.value
        lotStartLabel.text = AppLocalizedKeys.lotStarts.value
        
    }
}

// MARK: - Product Coll View Model

struct ProductCellViewModel {
    let name: String?
    let imageURL: String?

    let price: Int?
    let offer: Int?
    let currency: String?

    let endDate: Double?

    // MARK: - Formatted Text
    var priceText: String = ""
    var offerText: String? = nil
    var days: String = ""
    var hours: String = ""
    var minutes: String = ""

    // MARK: - Visibility Logic
    var shouldShowOffer: Bool = false
    var shouldShowCountdown: Bool = false

    init(product: ProductModel) {
        self.name = product.name
        self.imageURL = product.image
        self.price = product.price
        self.offer = product.offer
        self.currency = product.currency
        self.endDate = product.endDate

        // Price + Currency
        if let price = price, let currency = currency {
            self.priceText = "\(price) \(currency)"
        }

        // Offer Text
        if let offer = offer, let currency = currency {
            self.offerText = "\(offer) \(currency)"
            self.shouldShowOffer = true
        }

        // End Date Countdown
        if let endDate = endDate {
            self.shouldShowCountdown = true
            let time = TimeFormatterHelper.extractTimeComponents(from: endDate)
            self.days = "\(time.days)"
            self.hours = "\(time.hours)"
            self.minutes = "\(time.minutes)"
        }
    }
}

//MARK: - Cell Identifier -

extension ProductCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "ProductCollectionViewCell", bundle: nil)
    }
    static let identifier = "ProductCollectionViewCell"
}
