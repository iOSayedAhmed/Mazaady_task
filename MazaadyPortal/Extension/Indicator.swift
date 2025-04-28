//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

@available(iOS 13.0, *)
public struct Indicator {
    
    static let indicator = UIActivityIndicatorView(style: .large)
    @available(iOS 13.0, *)
    public static func createIndicator(on vc: UIViewController, start: Bool) {
        DispatchQueue.main.async {
            indicator.center = vc.view.center
            indicator.color = .gray
            vc.view.addSubview(indicator)
            if start {
                indicator.startAnimating()
            }else {
                indicator.stopAnimating()
            }
        }
    }
}
