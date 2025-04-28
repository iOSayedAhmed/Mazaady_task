//
//  UnderlineSegmentedControl.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//


import UIKit

class UnderlineSegmentedControl: UISegmentedControl {

    private let underlineHeight: CGFloat = 2.0
    private var underlineView: UIView!

    private var selectedColor: UIColor = SystemDesign.AppColors.primary.color
    private var unselectedColor: UIColor = SystemDesign.AppColors.grayG3.color

    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        removeBackgroundAndDivider()
        setupTextAttributes()
        addUnderline()
        handleSemanticDirection()
    }

    private func setupTextAttributes() {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: unselectedColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]

        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }

    private func removeBackgroundAndDivider() {
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    private func addUnderline() {
        underlineView = UIView()
        underlineView.backgroundColor = selectedColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        updateUnderlinePosition()
    }

    private func handleSemanticDirection() {
        // Set direction based on language
        if LocalizationManager.shared.getLanguage() == .Arabic {
            semanticContentAttribute = .forceRightToLeft
        } else {
            semanticContentAttribute = .forceLeftToRight
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderlinePosition()
    }

    private func updateUnderlinePosition() {
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let selectedIndex = CGFloat(selectedSegmentIndex)

        let xPosition = LocalizationManager.shared.getLanguage() == .Arabic ?
            bounds.width - segmentWidth * (selectedIndex + 1) :
            segmentWidth * selectedIndex

        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame = CGRect(
                x: xPosition,
                y: self.bounds.height - self.underlineHeight,
                width: segmentWidth,
                height: self.underlineHeight
            )
        }
    }

    override var selectedSegmentIndex: Int {
        didSet {
            updateUnderlinePosition()
        }
    }

    /// Reload segment titles using localization
    func setLocalizedItems(keys: [AppLocalizedKeys]) {
        removeAllSegments()
        for (index, key) in keys.enumerated() {
            insertSegment(withTitle: key.value, at: index, animated: false)
        }
    }
}
