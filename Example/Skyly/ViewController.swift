//
//  ViewController.swift
//  Skyly
//
//  Created by Philippe Auriach on 01/31/2022.
//  Copyright (c) 2022 Philippe Auriach. All rights reserved.
//

import UIKit
import Skyly
import AppTrackingTransparency

class ViewController: UIViewController {

    lazy var request: OfferWallRequest = {
        let request = OfferWallRequest(userId: "YOUR_USER_ID")
        
        request.zipCode = "75017" // optional
        request.userAge = 31 // optional
        request.userGender = .Male // optional
        request.userSignupDate = Date(timeIntervalSince1970: 1643645866) // optional
        request.callbackParameters = ["param0", "param1"] // optional
        
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in            
            }
        }
    }

    @IBAction func onAskForOffers(_ sender: Any) {
        Skyly.shared.getOfferWall(request: request) { error, offers in
            if let error = error {
                print("ERROR \(error)")
                return
            }
            print("We got data from offerwall \(String(describing: offers))")
        }
    }
    
    @IBAction func onTapCopyUrl(_ sender: Any) {
        if let hostedOfferwallUrl = Skyly.shared.getHostedOfferwallUrl(request: request) {
            print("We can open this in a webview: \(hostedOfferwallUrl)")
            UIPasteboard.general.string = hostedOfferwallUrl.absoluteString
        }
    }
    
    @IBAction func onTapOpenWallInBrowser(_ sender: Any) {
        Skyly.shared.showOfferwall(request: request, mode: .browser)
    }
    
    @IBAction func onTapOpenWallInApp(_ sender: Any) {
        Skyly.shared.showOfferwall(request: request, mode: .webView)
    }
}

