import UIKit

class Artwork {
    var title: String
    var dateCreated: Date
    var image: UIImage?
    var pastels: [Pastel]
    var comments: [Comment]

    init(title: String = "", dateCreated: Date = Date(), image: UIImage? = nil, pastels: [Pastel] = [], comments: [Comment] = []) {
        self.title = title
        self.dateCreated = dateCreated
        self.image = image
        self.pastels = pastels
        self.comments = comments
    }
}

class Comment {
    var name: String
    var text: String
    var date: Date
    var reactions: [String: Int]
    var myReactions: Set<String>

    init(name: String, text: String, date: Date = Date()) {
        self.name = name
        self.text = text
        self.date = date
        self.reactions = [:]
        self.myReactions = []
    }

    func toggleReaction(_ emoji: String) {
        if myReactions.contains(emoji) {
            myReactions.remove(emoji)
            reactions[emoji, default: 0] -= 1
            if reactions[emoji] == 0 { reactions[emoji] = nil }
        } else {
            myReactions.insert(emoji)
            reactions[emoji, default: 0] += 1
        }
    }
}
