//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit

public struct Alert {
    private static func createBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okButton)
        vc.present(alert, animated: true, completion: nil)
    }
    
    public static func failedToConnectWithServerAlert(on vc: UIViewController){
        createBasicAlert(on: vc, with: "", message: "Something went wrong, please try again.")
    }
    
    public static func defaultAlert(on vc: UIViewController, title: String = "", message: String){
        createBasicAlert(on: vc, with: title, message: message)
    }
}
