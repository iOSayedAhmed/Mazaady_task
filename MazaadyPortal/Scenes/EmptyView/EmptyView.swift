//
//  EmptyView.swift
//  Remat-app
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit
import RxSwift
import RxRelay

class EmptyView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewheightConstraint: NSLayoutConstraint!
    
    var imageWidth: CGFloat = 240.0 {
        didSet {
            imageViewWidthConstraint.constant = imageWidth
        }
    }
    
    var imageHeight: CGFloat = 240.0 {
        didSet {
            imageViewheightConstraint.constant = imageHeight
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        fromNib()
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    func configure(image: UIImage? = nil, title: String? = nil, description: String? = nil) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
