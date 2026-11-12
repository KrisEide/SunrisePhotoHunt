import Foundation
import SwiftData


@Model
final class PhotoSpot {
    var id: UUID
    var title: String
    var notes: String
    var latitude: Double
    var longitude: Double
    var plannedDate: Date
    var isPhotographed: Bool
    var photoData: Data? // Legge til bilde er valgfritt
    var createdAt: Date
    
    // Bildene som tilhører fotostedet.
    @Relationship(deleteRule: .cascade)
    var photos: [SpotPhoto] = []
    
    init(id: UUID, title: String, notes: String, latitude: Double, longitude: Double, plannedDate: Date, isPhotographed: Bool, photoData: Data? = nil, createdAt: Date) {
        self.id = id
        self.title = title
        self.notes = notes
        self.latitude = latitude
        self.longitude = longitude
        self.plannedDate = plannedDate
        self.isPhotographed = isPhotographed
        self.photoData = photoData
        self.createdAt = createdAt
    }
    
}

