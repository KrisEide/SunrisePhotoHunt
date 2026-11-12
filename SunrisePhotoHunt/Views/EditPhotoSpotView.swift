
import SwiftUI
import SwiftData

import PhotosUI // Lar brukeren velge bilder fra bildebiblioteket.

struct EditPhotoSpotView: View {

    // Fotostedet som skal redigeres.
    @Bindable var spot: PhotoSpot

    // Gir beskjed til detaljvisningen dersom stedet skal slettes.
    var onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showingDeleteAlert = false
    
    @State private var selectedPhotos: [PhotosPickerItem] = []

    var body: some View {
        Form {
            Section("Photo Spot") {
                TextField("Spot name", text: $spot.title)

                TextField("Notes", text: $spot.notes, axis: .vertical)
                    .lineLimit(4...8)
            }
            
            
            Section("Status") {

                // Lar brukeren velge om fotostedet er fotografert.
                Picker("Status", selection: $spot.isPhotographed) {
                    Text("Planned").tag(false)
                    Text("Photographed").tag(true)
                }
            }
            
            
            
            Section("Photos") {

                PhotosPicker(selection: $selectedPhotos, matching: .images) {
                    Label("Add Photos", systemImage: "photo.on.rectangle")
                }
                .onChange(of: selectedPhotos) { _, newPhotos in
                    Task {
                        // Lagrer hvert valgte bilde på fotostedet.
                        for photo in newPhotos {
                            if let data = try? await photo.loadTransferable(type: Data.self) {
                                spot.photos.append(SpotPhoto(imageData: data))
                            }
                        }

                        selectedPhotos = []
                    }
                }
            }
            
            
            ForEach(spot.photos) { photo in
                HStack {
                    if let image = UIImage(data: photo.imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(8)
                    }

                    Spacer()

                    Button(role: .destructive) {
                        spot.photos.removeAll { $0.id == photo.id }
                        modelContext.delete(photo)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                }
            }

            
            




            // Sletteknapp nederst i redigeringsvinduet.
            Section {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete Photo Spot", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Edit Photo Spot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        // Ber om bekreftelse før sletting.
        .alert("Delete Photo Spot?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this photo spot?")
        }
    }
}
