//
//  AppDelegate.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 28/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ContainerViewController()
        window!.makeKeyAndVisible()
        return true
    }

   
}

