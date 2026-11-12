
import Foundation
import SwiftData

@Model
final class SpotPhoto {

    var id: UUID

    // Lagrer bildedata utenfor selve databasen når mulig.
    @Attribute(.externalStorage)
    var imageData: Data

    init(imageData: Data) {
        self.id = UUID()
        self.imageData = imageData
    }
}

