
import SwiftUI
import SwiftData

import CoreLocation

@main
struct MyApp: App {
    
    @State private var userLocationRepository =
        UserLocationRepository(locationManager: CLLocationManager())

    // Oppretter lagringen for fotostedene våre.
    let photoSpotContainer: ModelContainer = {
        do {
            return try ModelContainer(for: PhotoSpot.self)
        } catch {
            fatalError("Could not create PhotoSpot container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(photoSpotContainer)
                .environment(userLocationRepository)
        }
    }
}
