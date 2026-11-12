
import SwiftUI
import SwiftData

struct MySpotsView: View {

    // Henter lagrede fotosteder, med de nyeste først.
    @Query(sort: \PhotoSpot.createdAt, order: .reverse)
    private var photoSpots: [PhotoSpot]

    // Fotostedet brukeren velger fra listen.
    @State private var selectedSpot: PhotoSpot?

    var body: some View {
        NavigationStack {
            List {
                ForEach(photoSpots) { spot in
                    Button {
                        selectedSpot = spot
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .foregroundStyle(.orange)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(spot.title)
                                    .font(.headline)

                                if !spot.notes.isEmpty {
                                    Text(spot.notes)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            
                            // Viser om fotostedet er planlagt eller fotografert.
                            if spot.isPhotographed {
                                Label("Photographed", systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                            } else {
                                Label("Planned", systemImage: "clock")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }


                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("My Spots")

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

