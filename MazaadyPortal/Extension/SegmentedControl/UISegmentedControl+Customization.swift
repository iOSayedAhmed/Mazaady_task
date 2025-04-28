//
//  UISegmentedControl+Customization.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

extension UISegmentedControl {
    func setItems(items: [String]) {
        let index = selectedSegmentIndex == -1 ? 0 : selectedSegmentIndex
        removeAllSegments()
        
        for i in 0...items.count-1{
            insertSegment(withTitle: items[i], at: i, animated: false)
        }
        selectedSegmentIndex = index
    }
}

