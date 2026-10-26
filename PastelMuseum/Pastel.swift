import UIKit

enum PastelBrand: String, CaseIterable, Codable {
    case mungyo = "Mungyo Gallery"
    case sennelier = "Sennelier"
    case caranDAche = "Caran d’Ache (Neopastel)"
    case meeden = "Meeden"
    case unknownBrand = "Unknown"
}

struct Pastel: Codable, Identifiable{
    var id = UUID()
    var color: String
    var brand: PastelBrand
    var colorID: Int
    var dateAcquired: Date
    var colorSwatch: RGBColor

    init(color: String = "None", brand: PastelBrand = .unknownBrand, colorID: Int = -1, dateAcquired: Date = Date(), colorSwatch: RGBColor) {
        self.color = color
        self.brand = brand
        self.colorID = colorID
        self.dateAcquired = dateAcquired
        self.colorSwatch = colorSwatch
    }
}

struct RGBColor: Codable {
    var red: Int
    var green: Int
    var blue: Int
}

extension Pastel {
    var swatchUIColor: UIColor {
        UIColor(
            red: CGFloat(colorSwatch.red) / 255,
            green: CGFloat(colorSwatch.green) / 255,
            blue: CGFloat(colorSwatch.blue) / 255,
            alpha: 1        )
    }
}
