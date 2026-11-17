
import SwiftUI

import SwiftData

import CoreLocation

struct PhotoSpotDetailView: View {

    // Fotostedet som brukeren har valgt.
    let spot: PhotoSpot

    @Environment(\.dismiss) private var dismiss
    
    @Environment(UserLocationRepository.self)
    private var userLocationRepository

    // Bestemmer om redigeringsskjermen skal vises.
    @State private var isEditing = false
    
    @Environment(\.modelContext) private var modelContext

    // Husker om fotostedet skal slettes når redigeringsvinduet lukkes.
    @State private var shouldDeleteSpot = false
    
    // Holder på soltidene fra API-et.
    @State private var sunTimes: SunriseResponse?

    // Holder styr på om API-kallet feilet.
    @State private var sunTimesError = false

    var body: some View {
        Form {
            Section("Photo Spot") {
                Text(spot.title)
                    .font(.title2)
                    .bold()

                Text(spot.notes)
            }
            // Viser statusen til fotostedet.
            Text(spot.isPhotographed ? "Photographed" : "Planned")
                .foregroundStyle(.secondary)
            
            
            Section("Photos") {

                if spot.photos.isEmpty && spot.photoData == nil {
                    Text("No photos added yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {

                            // Viser eventuelt bilde fra den gamle løsningen.
                            if let data = spot.photoData,
                               let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipped()
                            }

                            // Viser alle bildene som er lagt til.
                            ForEach(spot.photos) { photo in
                                if let image = UIImage(data: photo.imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 140)
                                        .clipped()
                                }
                            }
                        }
                    }
                }
            }
            
            // Viser bare planlagt dato hvis stedet ikke er fotografert.
            if !spot.isPhotographed {
                Section("Planning") {
                    Text(spot.plannedDate, format: .dateTime.day().month().year())
                }
            }
            
            
            if !spot.isPhotographed {
                Section("Sun Times") {

                    if let times = sunTimes {

                        if let sunrise = times.sunrise {
                            HStack {
                                Text("Sunrise")
                                Spacer()
                                Text(formattedTime(sunrise, timeZoneID: times.tzid))
                            }
                        } else {
                            Text("Sunrise unavailable")
                        }

                        if let sunset = times.sunset {
                            HStack {
                                Text("Sunset")
                                Spacer()
                                Text(formattedTime(sunset, timeZoneID: times.tzid))
                            }
                        } else {
                            Text("Sunset unavailable")
                        }

                        Link(
                            "Sun data by Sunrise-Sunset.org",
                            destination: URL(string: "https://sunrise-sunset.org")!
                        )
                        .font(.caption)

                    } else if sunTimesError {
                        Text("Could not load sun times.")
                            .foregroundStyle(.secondary)

                    } else {
                        ProgressView("Loading sun times...")
                    }
                }
            }



            
            
            Section("Location") {

                // Viser avstanden til fotostedet.
                if let userLocation = userLocationRepository.currentLocation {
                    let spotLocation = CLLocation(
                        latitude: spot.latitude,
                        longitude: spot.longitude
                    )

                    let distance = userLocation.distance(from: spotLocation)

                    Label(
                        "\(distance / 1000, specifier: "%.1f") km away",
                        systemImage: "location"
                    )
                } else {
                    Text("Distance unavailable")
                        .foregroundStyle(.secondary)
                }
            }


        }
        .navigationTitle("Spot Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        // Åpner en egen skjerm for å redigere fotostedet.
        
        .sheet(isPresented: $isEditing, onDismiss: {
            if shouldDeleteSpot {
                // Sletter stedet etter at redigeringsvinduet er lukket.
                modelContext.delete(spot)
                dismiss()
            }
        }) {
            NavigationStack {
                EditPhotoSpotView(spot: spot) {
                    shouldDeleteSpot = true
                    isEditing = false
                }
            }
            
            
            .task(id: spot.isPhotographed ? nil : spot.plannedDate) {

                // Henter bare soltider for planlagte fotosteder.
                guard !spot.isPhotographed else {
                    sunTimes = nil
                    return
                }

                sunTimes = nil
                sunTimesError = false

                do {
                    sunTimes = try await SunriseService().fetchSunTimes(
                        latitude: spot.latitude,
                        longitude: spot.longitude,
                        date: spot.plannedDate
                    )
                } catch {
                    sunTimesError = true
                    print("Error loading sun times: \(error)")
                }
            }
            
            

        } // end of body
        
        
        // Formaterer klokkeslettet etter fotostedets tidssone.
        private func formattedTime(_ date: Date, timeZoneID: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(identifier: timeZoneID) ?? .current

            return formatter.string(from: date)
        }

        

    }
}
