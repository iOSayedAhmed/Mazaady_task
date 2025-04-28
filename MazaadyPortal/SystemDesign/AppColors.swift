//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

extension SystemDesign {
    public enum AppColors: String {
        case primary
        case secondary
        case hueOrange
        case grayG3, grayG5
        case tabBar, gray, orange
        case thirdty
        case mergencyred
        case whiteBlack
        
        public var color: UIColor {
            return UIColor(named: self.rawValue) ?? UIColor()
        }
    }
}
