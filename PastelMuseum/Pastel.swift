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
        return UIColor(
            red: CGFloat(colorSwatch.0) / 255,
            green: CGFloat(colorSwatch.1) / 255,
            blue: CGFloat(colorSwatch.2) / 255,
            alpha: 1
        )
    }
}

final class PastelStore {
    static let shared = PastelStore()

    var pastels: [Pastel]
    var artworks: [Artwork]

    let explorePastels: [Pastel]
    let exploreArtworks: [Artwork]

    private init() {
        let jazzberry = Pastel(color: "Jazzberry Jam", brand: .mungyo, id: 276, dateAcquired: Date(), colorSwatch: (198, 1, 49))
        let viridian = Pastel(color: "Viridian Green", brand: .sennelier, id: 021, dateAcquired: Date(), colorSwatch: (0, 103, 80))

        pastels = [jazzberry, viridian]
        artworks = [
            Artwork(title: "Sample Artwork", dateCreated: Date(), image: UIImage(named: "sample_work_1"), pastels: [jazzberry, viridian])
        ]

        let cadmiumOrange = Pastel(color: "Cadmium Orange", brand: .caranDAche, id: 101, dateAcquired: Date(), colorSwatch: (237, 118, 14))
        let ultramarine = Pastel(color: "Ultramarine Blue", brand: .sennelier, id: 205, dateAcquired: Date(), colorSwatch: (18, 10, 143))
        let burntSienna = Pastel(color: "Burnt Sienna", brand: .meeden, id: 330, dateAcquired: Date(), colorSwatch: (138, 54, 15))
        let lemonYellow = Pastel(color: "Lemon Yellow", brand: .mungyo, id: 412, dateAcquired: Date(), colorSwatch: (250, 237, 39))
        explorePastels = [cadmiumOrange, ultramarine, burntSienna, lemonYellow]

        exploreArtworks = [
            Artwork(title: "Autumn Orchard", dateCreated: Date(), image: UIImage(named: "sample_work_1"), pastels: [cadmiumOrange, burntSienna]),
            Artwork(title: "Harbor at Dusk", dateCreated: Date(), image: UIImage(named: "sample_work_1"), pastels: [ultramarine, lemonYellow]),
            Artwork(title: "Citrus Grove", dateCreated: Date(), image: UIImage(named: "sample_work_1"), pastels: [lemonYellow, cadmiumOrange])
        ]
    }
    
    var nextAvailableID: Int {
        (pastels.map(\.id).max() ?? 0) + 1
    }

    func removePastel(at index: Int) {
        let removed = pastels.remove(at: index)
        for artwork in artworks {
            artwork.pastels.removeAll { $0 === removed }
        }
    }
    
    func removeArtwork(at index: Int) {
        artworks.remove(at: index)
    }
    
    func artworks(using pastel: Pastel) -> [Artwork] {
        artworks.filter { artwork in artwork.pastels.contains { $0 === pastel } }
    }
}
