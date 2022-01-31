import Foundation

// MARK: - FeedElement
public struct FeedElement: Codable {
    public let id, name, devName: String
    public let link, icon: String
    public let smallDescription, smallDescriptionHTML: String
    public let actions: [Action]

    enum CodingKeys: String, CodingKey {
        case id, name, devName = "devname", link, icon = "icone"
        case smallDescription = "small_description"
        case smallDescriptionHTML = "small_description_html"
        case actions
    }
}

// MARK: - Action
public struct Action: Codable {
    let id: String
    let amount: Double
    let text, html: String
}

typealias Feed = [FeedElement]
