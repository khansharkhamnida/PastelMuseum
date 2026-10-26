//
//  PastelDataStore.swift
//  PastelMuseum
//
//  Created by Shofia Ghazali on 26/10/26.
//


import Foundation

final class PastelDataStore {
    static let shared = PastelDataStore()

    private init() {}

    private var fileURL: URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documentsPath.appendingPathComponent("pastels.json")
    }

    func loadPastels() -> [Pastel] {
        do {
            let data = try Data(contentsOf: fileURL)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode([Pastel].self, from: data)
        } catch {
            print("Failed to load pastels: \(error)")
            return []
        }
    }


    func savePastels(_ pastels: [Pastel]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            let data = try encoder.encode(pastels)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save pastels: \(error)")
        }
    }
    
    func addItem(_ item: Pastel) {
        var pastels = loadPastels()
        pastels.append(item)
        savePastels(pastels)
    }

    func updateItem(_ item: Pastel) {
        var pastels = loadPastels()

        guard let index = pastels.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        pastels[index] = item
        savePastels(pastels)
    }

    func deleteItem(_ item: Pastel) {
        var pastels = loadPastels()
        pastels.removeAll { $0.id == item.id }
        savePastels(pastels)
    }

    func deleteItem(at index: Int) {
        var pastels = loadPastels()

        guard pastels.indices.contains(index) else {
            return
        }

        pastels.remove(at: index)
        savePastels(pastels)
    }
    
}
