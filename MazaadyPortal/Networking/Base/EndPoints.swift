//
//  File.swift
//  
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

public enum EndPoints: String {
    
    case baseURL = "https://stagingapi.mazaady.com/api/interview-tasks/"
    
    public var value: String {
        return self.rawValue
    }
}
