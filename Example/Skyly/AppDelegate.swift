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

        Skyly.shared.getOffers(offerType: .Incent) { error, offers in
            print("We got data from incent offers \(String(describing: offers))")
        }
        Skyly.shared.getOffers(offerType: .NonIncent) { error, offers in
            print("We got data from nonincent offers \(String(describing: offers))")
        }
        
        // Override point for customization after application launch.
        return true
    }
    
}

