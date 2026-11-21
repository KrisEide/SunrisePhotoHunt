
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
            
            
            // -------------------------------------------------------
            //Her starter lys tidslinjen
            if !spot.isPhotographed {
                Section("Light Timeline") {

                    if let times = sunTimes {

                        VStack(alignment: .leading, spacing: 16) {

                            Text("MORNING")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            timelineRow(
                                icon: "moon.stars",
                                color: .blue,
                                title: "Blue Hour",
                                time: formattedPeriod(
                                    times.blue_hour?.morning,
                                    timeZoneID: times.tzid
                                ),
                                
                            )

                            timelineRow(
                                icon: "sun.max",
                                color: .orange,
                                title: "Golden Hour",
                                time: formattedPeriod(
                                    times.golden_hour?.morning,
                                    timeZoneID: times.tzid
                                ),
                                
                            )

                            timelineRow(
                                icon: "sunrise",
                                color: .orange,
                                title: "Sunrise",
                                time: times.sunrise.map {
                                    formattedTime($0, timeZoneID: times.tzid)
                                } ?? "Unavailable",
                                showLine: false
                            )

                            Divider()

                            Text("AFTERNOON / EVENING")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            timelineRow(
                                icon: "sun.max",
                                color: .orange,
                                title: "Golden Hour",
                                time: formattedPeriod(times.golden_hour?.evening, timeZoneID: times.tzid),
                            )

                            timelineRow(
                                icon: "sunset",
                                color: .orange,
                                title: "Sunset",
                                time: times.sunset.map {
                                    formattedTime($0, timeZoneID: times.tzid)
                                } ?? "Unavailable",
                            )

                            timelineRow(
                                icon: "moon.stars",
                                color: .blue,
                                title: "Blue Hour",
                                time: formattedPeriod(times.blue_hour?.evening, timeZoneID: times.tzid),
                                showLine: false
                            )

                            Link(
                                "Sun data by Sunrise-Sunset.org",
                                destination: URL(string: "https://sunrise-sunset.org")!
                            )
                            .font(.caption2)
                            
                        }
                        .padding(.vertical, 8)

                    
                    } else if sunTimesError {

                        Text("Could not load sun times.")
                            .foregroundStyle(.secondary)

                        Button("Try Again") {
                            Task {
                                await loadSunTimes()
                            }
                        }


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
        }
        
        // Jeg har valgt å hente soltidene når brukeren åpner et fotosted,
        // slik at informasjonen alltid er basert på stedets koordinater og
        // planlagte dato. Soltidene lagres derfor ikke permanent i SwiftData.
        .task(id: spot.isPhotographed ? nil : spot.plannedDate) {
            await loadSunTimes()
        }
    }

    // Jeg bruker tidssonen fra API-et slik at soltidene vises i lokal tid
    // for fotostedet. Hvis jeg for eksempel lagrer et sted i Japan,
    // vil tidene vises i japansk tid, selv om jeg er i Norge.
    
    private func formattedTime(_ date: Date, timeZoneID: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: timeZoneID) ?? .current

        return formatter.string(from: date)
    }
    
    
    // Henter soltider for det valgte fotostedet.
    private func loadSunTimes() async {

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
            // Hvis brukeren lukker visningen mens API-kallet pågår, kan oppgaven
            // bli avbrutt. Da vil jeg ikke behandle det som en vanlig nettverksfeil.
            if !Task.isCancelled {
                sunTimesError = true
                print("Error loading sun times: \(error)")
            }
        }
    }

    
    
    // Formaterer start- og sluttidspunkt for en lysperiode.
    private func formattedPeriod(_ period: LightPeriod?, timeZoneID: String) -> String {

        guard let begin = period?.begin,
              let end = period?.end else {
            return "Unavailable"
        }

        let startTime = formattedTime(begin, timeZoneID: timeZoneID)
        let endTime = formattedTime(end, timeZoneID: timeZoneID)

        return "\(startTime) – \(endTime)"
    }
    
    
    // Lager en rad i tidslinjen med ikon, tidspunkt og beskrivelse.
    private func timelineRow(
        icon: String,
        color: Color,
        title: String,
        time: String,
        showLine: Bool = true
    ) -> some View {

        HStack(alignment: .top, spacing: 12) {

            VStack(spacing: 4) {

                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24, height: 24)

                // Jeg ønsket å koble sammen ikonene i tidslinjen med en tynn strek.
                // Derfor bruker jeg et smalt rektangel som plasseres under hvert ikon.
                if showLine {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 2, height: 32)
                }
            }

            VStack(alignment: .leading, spacing: 8) {

                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .bold()

                    Spacer(minLength: 8)

                    Text(time)
                        .fontWeight(title == "Sunrise" || title == "Sunset" ? .bold : .regular)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                
            }
        }
    }


}
