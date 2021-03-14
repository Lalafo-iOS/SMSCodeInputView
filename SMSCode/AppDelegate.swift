//
//  AppDelegate.swift
//  SMSCode
//
//  Created by Sergey Zalozniy on 12.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white

        return true
    }

}

