//
//  AppDelegate.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseNavigationController") as? BaseNavigationController else { return true }
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }

}

