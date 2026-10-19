//
//  Pastel.swift
//  PastelMuseum
//
//  Created by Dian Maisara on 18/10/26.
//
import UIKit

enum PastelBrand: String, CaseIterable {
    case mungyo = "Mungyo Gallery"
    case sennelier = "Sennelier"
    case caranDAche = "Caran d’Ache (Neopastel)"
    case meeden = "Meeden"
    case unknownBrand = "Unknown"
}

// future version uses struct to save details into disk
class Pastel {
    var color: String
    var brand: PastelBrand
    var id: Int
    var dateAcquired: Date
    var colorSwatch: (Int, Int, Int)
    var hardnessGrading: Int?
    var toothGrading: Int?
    var lightfastnessGrading: Int?
    var featuredWorks: String?
    
    private var maximumGrading = 5
    private var minimumGrading = 1
    
    // photo to be uploaded
    // colorSwatch defaults to nil so your existing Pastel(...) calls still work
    init(color: String, brand: PastelBrand, id: Int, dateAcquired: Date, colorSwatch: (Int, Int, Int)) {
        self.color = color
        self.brand = brand
        self.id = id
        self.dateAcquired = dateAcquired
        self.colorSwatch = colorSwatch
    }
    
    func setGradings(hardness: Int, tooth: Int, lightfastness: Int) {
        guard hardness >= minimumGrading && hardness <= maximumGrading else { return }
        guard tooth >= minimumGrading && tooth <= maximumGrading else { return }
        guard lightfastness >= minimumGrading && lightfastness <= maximumGrading else { return }
        
        hardnessGrading = hardness
        toothGrading = tooth
        lightfastnessGrading = lightfastness
    }
}

// turns the (R, G, B) tuple into something the views can use
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
