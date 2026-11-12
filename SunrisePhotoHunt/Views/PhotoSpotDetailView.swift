
import SwiftUI

import SwiftData

struct PhotoSpotDetailView: View {

    // Fotostedet som brukeren har valgt.
    let spot: PhotoSpot

    @Environment(\.dismiss) private var dismiss

    // Bestemmer om redigeringsskjermen skal vises.
    @State private var isEditing = false
    
    @Environment(\.modelContext) private var modelContext

    // Husker om fotostedet skal slettes når redigeringsvinduet lukkes.
    @State private var shouldDeleteSpot = false

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


            Section("Location") {
                Text("Latitude: \(spot.latitude)")
                Text("Longitude: \(spot.longitude)")
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
        }

    }
}
