//
//  AppDelegate.swift
//  Skyly
//
//  Created by Philippe Auriach on 01/31/2022.
//  Copyright (c) 2022 Philippe Auriach. All rights reserved.
//

import UIKit
import Skyly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Skyly.shared.apiKey = "API_KEY"
        Skyly.shared.publisherId = "PUB_ID"
        Skyly.shared.apiDomain = "www.mob4pass.com" // optional
        
        // Override point for customization after application launch.
        return true
    }
}

