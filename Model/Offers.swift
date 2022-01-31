//
//  Offers.swift
//  Skyly
//
//  Created by Philippe Auriach on 31/01/2022.
//

import Foundation

public enum Device: String {
    case iPhone = "iphone"
    case iPod = "ipod"
    case iPad = "ipad"
    case Android = "android"
}

public enum Support: String {
    case Web = "web"
    case App = "app"
}

public enum ConnectionType: String {
    case Unknown = "unknown"
    case Ethernet = "ethernet"
    case Wifi = "wifi"
    case Generic = "generic"
    case _2G = "2g"
    case _3G = "3g"
    case _4G = "4g"
}

public struct ProductPrice: Codable {
    let amount: Double
    let currency: String
}

public struct Offer {
    let id, name: String
    let createdAt: Date?
    let dailyCapping: Int?
    let icon, link: String
    let isIncentive, isDownload: Bool
    //TODO: let trackingType: JSONNull?
    let device: [Device]
    let support: [Support]
    let osVersionMin: Double?
    //TODO: let geolocation: Geolocation
    //TODO: let carriersInc, carriersExc: [JSONAny]
    let connectionType: [ConnectionType]
    let cappingUserDay: Int?
    let productId, productCompany, productDescription: String
    //TODO: let privateLevel: String
    let productPrice: ProductPrice
    let actions: [JSONAction]
    
    init(fromJSON: JSONOffer) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.id = fromJSON.id
        self.name = fromJSON.name
        self.createdAt = fromJSON.createdAt.asOfferDate
        self.dailyCapping = fromJSON.dailyCapping.asInt
        self.icon = fromJSON.icon
        self.link = fromJSON.link
        self.isIncentive = fromJSON.incentive == "1"
        self.isDownload = fromJSON.isDownload == "1"
        
        self.device = fromJSON.device.compactMap { Device(rawValue: $0) }
        self.support = fromJSON.support.compactMap { Support(rawValue: $0) }
        
        self.osVersionMin = fromJSON.osVersionMin.asDouble
        
        self.connectionType = fromJSON.connectionType.compactMap { ConnectionType(rawValue: $0) }
        self.cappingUserDay = fromJSON.cappingUserDay.asInt
        self.productId = fromJSON.productID
        self.productCompany = fromJSON.productCompany
        self.productDescription = fromJSON.productDescription
        
        self.productPrice = ProductPrice(amount: fromJSON.productPrice.amount.asDouble!, currency: fromJSON.productPrice.currency)
        self.actions = fromJSON.actions
    }
}
