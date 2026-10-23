import UIKit

enum PastelBrand: String, CaseIterable {
    case mungyo = "Mungyo Gallery"
    case sennelier = "Sennelier"
    case caranDAche = "Caran d’Ache (Neopastel)"
    case meeden = "Meeden"
    case unknownBrand = "Unknown"
}

class Pastel {
    var color: String
    var brand: PastelBrand
    var id: Int
    var dateAcquired: Date
    var colorSwatch: (Int, Int, Int)

    init(color: String = "None", brand: PastelBrand = .unknownBrand, id: Int = -1, dateAcquired: Date = Date(), colorSwatch: (Int, Int, Int) = (-1, -1, -1)) {
        self.color = color
        self.brand = brand
        self.id = id
        self.dateAcquired = dateAcquired
        self.colorSwatch = colorSwatch
    }
}

extension Pastel {
    var swatchUIColor: UIColor {
        UIColor(
            red: CGFloat(colorSwatch.0) / 255,
            green: CGFloat(colorSwatch.1) / 255,
            blue: CGFloat(colorSwatch.2) / 255,
            alpha: 1
        )
    }
}
