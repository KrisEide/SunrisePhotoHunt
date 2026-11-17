
import SwiftUI
import SwiftData
import CoreLocation

struct MySpotsView: View {

    // Henter lagrede fotosteder, med de nyeste først.
    @Query(sort: \PhotoSpot.createdAt, order: .reverse)
    private var photoSpots: [PhotoSpot]

    // Fotostedet brukeren velger fra listen.
    @State private var selectedSpot: PhotoSpot?
    
    // Gir tilgang til brukerens posisjon.
    @Environment(UserLocationRepository.self)
    private var userLocationRepository

    var body: some View {
        NavigationStack {
            List {
                
                ForEach(photoSpots) { spot in
                    Button {
                        selectedSpot = spot
                    } label: {
                        HStack(spacing: 12) {

                            VStack(alignment: .leading, spacing: 10) {
                                Text(spot.title)
                                    .font(.headline)

                                HStack(spacing: 16) {

                                    // Viser avstand til fotostedet.
                                    if let userLocation = userLocationRepository.currentLocation {
                                        let spotLocation = CLLocation(
                                            latitude: spot.latitude,
                                            longitude: spot.longitude
                                        )

                                        let distance = userLocation.distance(from: spotLocation)

                                        Label(
                                            "\(distance / 1000, specifier: "%.1f") km",
                                            systemImage: "location"
                                        )
                                        .foregroundStyle(.secondary)
                                    }

                                    // Viser statusen til fotostedet.
                                    if spot.isPhotographed {
                                        Label("Photographed", systemImage: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else {
                                        Label("Planned", systemImage: "clock")
                                            .foregroundStyle(.orange)
                                    }
                                }
                                .font(.caption)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }

            }
            .navigationTitle("My Spots")
            .onAppear {
                userLocationRepository.requestAuthorization()
            }

            // Viser en melding hvis brukeren ikke har lagret noen steder.
            .overlay {
                if photoSpots.isEmpty {
                    ContentUnavailableView(
                        "No Photo Spots",
                        systemImage: "camera",
                        description: Text("Add your first spot from the map.")
                    )
                }
            }

            // Åpner samme detaljvisning som vi bruker på kartet.
            .sheet(item: $selectedSpot) { spot in
                NavigationStack {
                    PhotoSpotDetailView(spot: spot)
                }
            }
        }
    }
}

