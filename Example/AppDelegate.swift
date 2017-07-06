//
//  AppDelegate.swift
//  Example
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit
import ParallaxPagingViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewControllers = [
            ParallaxChildViewController(index:0),
            ParallaxChildViewController(index:1),
            ParallaxChildViewController(index:2)
        ]

        let pageView = ParallaxPagingViewController(viewControllers: viewControllers)
        pageView.setInfinite(false)
        window?.rootViewController = pageView
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

