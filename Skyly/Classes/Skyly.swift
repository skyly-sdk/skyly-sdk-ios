import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import CommonCrypto

public enum OfferType: String {
    /// Rewarded offers, users will be rewarded with an in game credit
    case Incent = "incent"
    /// Non rewarded offers
    case NonIncent = "nonincent"
}

@objc
public class Skyly: NSObject {
    
    public static let shared = Skyly()
    
    private static let API_URL = "https://www.mobsuccess.com"
    
    public var apiKey: String?
    public var publisherId: String?
    
    private override init() {}
    
    /// Fetch offers.
    ///
    /// - Warning: the callback might not be called on the main thread, if you want to update the UI you should dispatch the result in the MainQueue before using it.
    /// - Parameter offerType: type of offers to fetch
    /// - Parameter callback: get called with the offers or an error
    /// - Returns: nothing
    public func getOffers(offerType: OfferType, completion: @escaping (_ error: String?, _ offers: [Offer]?) -> ()) {
        guard let publisherId = self.publisherId, let apiKey = self.apiKey else {
            print("🛑 Skyly needs to be configured with an apiKey and publisherId before being called")
            return
        }
        
        var url = URLComponents(string: "\(Skyly.API_URL)/api/offers/v2/\(offerType.rawValue)")!
        
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        
        let timestamp = formatter.string(from: Date().timeIntervalSince1970 as NSNumber)!
        guard let hash = "\(timestamp)\(apiKey)".data(using: .utf8)?.sha1 else {
            print("FATAL: Unable to compute hash")
            return
        }
        
        let params: [String : String] = [
            "pubid" : publisherId,
            "timestamp" : timestamp,
            "hash" : hash
        ]
        
        var items: [URLQueryItem] = []
        for (key, value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        url.queryItems = items
        
        print("calling \(url.url!)")
        
        var request = URLRequest(url: url.url!, timeoutInterval: 30)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("ERROR" + String(describing: error))
                completion(String(describing: error), nil)
                return
            }

            guard let offers = try? JSONDecoder().decode(JSONOffers.self, from: data) else {
                completion("Could not parse response", nil)
                return
            }
            
            completion(nil, offers.map { Offer(fromJSON: $0) })
        }
        
        task.resume()
    }
}
