//
//  OfferWallParametersUtils.swift
//  Skyly
//
//  Created by Philippe Auriach on 31/01/2022.
//

import AdSupport
import Foundation
import CoreTelephony
import AppTrackingTransparency

public enum Device: String {
    case iPhone = "iphone"
    case iPod = "ipod"
    case iPad = "ipad"
    case Unknown = "unknown"
}

class OfferWallParametersUtils {
    
    static func getCurrentDevice() -> Device {
        let name = UIDevice.current.model.replacingOccurrences(of: "Simulator", with: "")
        
        switch name {
        case _ where name.starts(with: "iPad"):
            return .iPad
        case _ where name.starts(with: "iPod"):
            return .iPod
        case _ where name.starts(with: "iPhone"):
            return .iPhone
        default:
            return .Unknown
        }
    }
    
    static func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    static func getIDFA() -> String? {
        
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus != .authorized {
                return nil
            }
        } else {
            if !ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                return nil
            }
        }
        
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    static func getLocale() -> Locale {
        if let preferred = Locale.preferredLanguages.first {
            return Locale(identifier: preferred)
        }
        return Locale.current
    }
    
    static func getCarrierCode() -> String? {
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            let carriers = networkInfo.serviceSubscriberCellularProviders

            if let carrier = carriers?.values.first(where: { $0.carrierName != nil }) {
                if let MCC = carrier.mobileCountryCode, let MNC = carrier.mobileNetworkCode {
                    return "\(MCC)-\(MNC)"
                }
            }
        }
        // Fallback on earlier versions
        if let carrier = networkInfo.subscriberCellularProvider {
            if let MCC = carrier.mobileCountryCode, let MNC = carrier.mobileNetworkCode {
                return "\(MCC)-\(MNC)"
            }
        }

        return nil
    }
}
