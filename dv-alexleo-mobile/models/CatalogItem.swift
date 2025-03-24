import Foundation

struct CatalogItem: Identifiable, Codable {
    let id = UUID()
    let unitPrice: Double
    let quantity: Int
    let gameName: String
    let gameEditor: String
    let sellerName: String
    let sellerSurname: String

    // Optional: Computed property for full seller name
    var sellerFullName: String {
        "\(sellerName) \(sellerSurname)"
    }
}