//
//  AppUtils.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit

class AppUtils: NSObject {
    static let shared = AppUtils()
    
    func setObject(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
