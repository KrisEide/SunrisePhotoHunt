
import SwiftUI

import PhotosUI // Lar brukeren velge bilder fra bildebiblioteket.

struct AddPhotoSpotView: View {
    
    // Leser koordinatene direkte fra kartskjermen.
    @Binding var coordinate: CLLocationCoordinate2D
    
    // Sender det nye fotostedet tilbake til kartskjermen.
    var onSave: (PhotoSpot) -> Void

    @Environment(\.dismiss) private var dismiss

    // Holder på det brukeren skriver i skjemaet.
    @State private var title: String = ""
    @State private var notes: String = ""
    
    @State private var isPhotographed = false
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var isSaving = false
    
    @State private var plannedDate = Date()

    var body: some View {
        NavigationStack {
            
            Form {
                TextField("Spot name", text: $title)
                TextField("Notes", text: $notes)

                // Viser koordinatene som ble valgt på kartet.
                Text("Latitude: \(coordinate.latitude)")
                Text("Longitude: \(coordinate.longitude)")
                    .foregroundStyle(.secondary)
                Section("Status") {
                    Picker("Status", selection: $isPhotographed) {
                        Text("Planned").tag(false)
                        Text("Photographed").tag(true)
                    }
                }
                
                if !isPhotographed {
                    Section("Planning") {
                        DatePicker(
                            "Planned Date",
                            selection: $plannedDate,
                            displayedComponents: .date
                        )
                    }
                }
                
                Section("Photos") {
                    PhotosPicker(selection: $selectedPhotos, matching: .images) {
                        Label("Add Photos", systemImage: "photo.on.rectangle")
                    }

                    if !selectedPhotos.isEmpty {
                        Text("\(selectedPhotos.count) photos selected")
                            .foregroundStyle(.secondary)
                    }
                }

            }
            .navigationTitle("New Photo Spot")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                   
                    Button("Save") {
                        isSaving = true

                        Task {
                            let newSpot = PhotoSpot(
                                id: UUID(),
                                title: title,
                                notes: notes,
                                latitude: coordinate.latitude,
                                longitude: coordinate.longitude,
                                plannedDate: plannedDate,
                                isPhotographed: isPhotographed,
                                createdAt: .now
                            )

                            // Jeg ønsket at brukeren skulle kunne legge til flere bilder på samme
                            // fotosted. Derfor gjør jeg de valgte bildene om til Data og legger
                            // dem til som SpotPhoto-objekter som kan lagres med SwiftData.
                            for photo in selectedPhotos {
                                if let data = try? await photo.loadTransferable(type: Data.self) {
                                    newSpot.photos.append(SpotPhoto(imageData: data))
                                }
                            }

                            onSave(newSpot)
                            dismiss()
                        }
                    }
                    .disabled(isSaving)

                }
            }

        }
    }
}


#Preview {
    AddPhotoSpotView(
        coordinate: .constant(
            CLLocationCoordinate2D(
                latitude: 59.9139,
                longitude: 10.7522
            )
        ),
        onSave: { _ in }
    )
}


