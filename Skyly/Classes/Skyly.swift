import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import CommonCrypto

public enum Gender: String {
    case Male = "m"
    case Female = "f"
}

public struct OfferWallRequest {
    /// Your unique id for the current user
    public var userId: String
    
    /// Current zipCode of the user, should be fetched from geolocation, not from geoip
    public var zipCode: String?
    
    /// Your user's age
    public var userAge: Int?
    
    /// Gender of the user, to access targetted campaigns
    public var userGender: Gender?
    
    /// Date at which your user did signup
    public var userSignupDate: Date?
    
    /// parameters you wish to get back in your callback
    public var callbackParameters: [String] = []
    
    public init(userId: String) {
        self.userId = userId
    }
}

@objc
public class Skyly: NSObject {
    
    public static let shared = Skyly()
    
    private static let API_URL = "https://www.mob4pass.com"
    
    public var apiKey: String?
    public var publisherId: String?
    
    private override init() {}
    
    /// Fetch OfferWall
    ///
    /// - Warning: Do NOT use the wall unless you got specific authorization from the user to collect and share those personal data for advertising
    ///
    public func getOfferWall(request: OfferWallRequest, completion: @escaping (_ error: String?, _ offers: [FeedElement]?) -> ()) {
        
        guard let publisherId = self.publisherId, let apiKey = self.apiKey else {
            let error = "🛑 Skyly needs to be configured with an apiKey and publisherId before being called"
            print(error)
            completion(error, nil)
            return
        }
        
        var url = URLComponents(string: "\(Skyly.API_URL)/api/feed/v2/")!
        
        let cleanNumberFormatter = NumberFormatter()
        cleanNumberFormatter.allowsFloats = false
        
        let timestamp = cleanNumberFormatter.string(from: Date().timeIntervalSince1970 as NSNumber)!
        guard let hash = "\(timestamp)\(apiKey)".data(using: .utf8)?.sha1 else {
            let error = "FATAL: Unable to compute hash"
            print(error)
            completion(error, nil)
            return
        }
        
        var params: [String : String?] = [
            "pubid" : publisherId,
            "timestamp" : timestamp,
            "hash" : hash,
            "userid" : request.userId,
            "device" : OfferWallParametersUtils.getCurrentDevice().rawValue,
            "devicemodel": UIDevice.current.localizedModel,
            "os_version": UIDevice.current.systemVersion,
            "is_tablet": OfferWallParametersUtils.getCurrentDevice() == .iPad ? "1" : "0",
            "country": Locale.current.regionCode,
            "zip": request.zipCode,
            "user_gender": request.userGender?.rawValue,
            "ip": OfferWallParametersUtils.getIPAddress(),
        ]
        
        if let userAge = request.userAge {
            params["user_age"] = cleanNumberFormatter.string(from: userAge as NSNumber)
        }
        
        if let signupTimestamp = request.userSignupDate?.timeIntervalSince1970 {
            params["user_signup_timestamp"] = cleanNumberFormatter.string(from: signupTimestamp as NSNumber)
        }
        
        if let idfa = OfferWallParametersUtils.getIDFA() {
            params["idfa"] = idfa
            params["idfasha1"] = idfa.data(using: .utf8)?.sha1
        }
        
        for i in 0..<request.callbackParameters.count {
            let param = request.callbackParameters[i]
            params["pub\(i)"] = param
        }
        
        var items: [URLQueryItem] = []
        for (key, value) in params {
            if let value = value {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        url.queryItems = items
        
#if DEBUG
        print("###################")
        print("Calling Offerwall : \(url.url!)")
        print("###################")
#endif
        
        var request = URLRequest(url: url.url!, timeoutInterval: 30)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("ERROR" + String(describing: error))
                completion(String(describing: error), nil)
                return
            }
            
            guard let elements = try? JSONDecoder().decode(Feed.self, from: data) else {
                let message = String(data: data, encoding: .utf8)
                completion("Could not parse feed response: \(String(describing: message))", nil)
                return
            }
            
            completion(nil, elements)
        }
        
        task.resume()
    }
}
