//
//  AppDelegate.swift
//  Skyly
//
//  Created by Philippe Auriach on 01/31/2022.
//  Copyright (c) 2022 Philippe Auriach. All rights reserved.
//

import UIKit
import Skyly
import AppTrackingTransparency

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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        let request = OfferWallRequest(userId: "YOUR_USER_ID")
        
        request.zipCode = "75017" // optional
        request.userAge = 31 // optional
        request.userGender = .Male // optional
        request.userSignupDate = Date(timeIntervalSince1970: 1643645866) // optional
        request.callbackParameters = ["param0", "param1"] // optional
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { authorization in
                Skyly.shared.getOfferWall(request: request) { error, offers in
                    if let error = error {
                        print("ERROR \(error)")
                        return
                    }
                    print("We got data from offerwall \(String(describing: offers))")                    
                }
            }
        } else {
            // Fallback on earlier versions
            Skyly.shared.getOfferWall(request: request) { error, offers in
                if let error = error {
                    print("ERROR \(error)")
                    return
                }
                print("We got data from offerwall \(String(describing: offers))")
            }
        }
        
    }
    
}

