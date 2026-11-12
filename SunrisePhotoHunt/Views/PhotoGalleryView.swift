
import SwiftUI
import SwiftData

struct PhotoGalleryView: View {

    @Query private var photoSpots: [PhotoSpot]
    @State private var selectedSpot: PhotoSpot?

    // Sjekker om noen fotosteder har bilder.
    private var hasPhotos: Bool {
        for spot in photoSpots {
            if !spot.photos.isEmpty || spot.photoData != nil {
                return true
            }
        }
        return false
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if hasPhotos {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160))],
                        spacing: 10
                    ) {
                        ForEach(photoSpots) { spot in

                            // Beholder eventuelle bilder fra den gamle løsningen.
                            if let data = spot.photoData,
                               let image = UIImage(data: data) {
                                photoButton(image, spot: spot)
                            }

                            ForEach(spot.photos) { photo in
                                if let image = UIImage(data: photo.imageData) {
                                    photoButton(image, spot: spot)
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    ContentUnavailableView(
                        "No Photos Yet",
                        systemImage: "photo.on.rectangle",
                        description: Text("Add photos to your photo spots.")
                    )
                }
            }
            .navigationTitle("My Gallery")
            .sheet(item: $selectedSpot) { spot in
                NavigationStack {
                    PhotoSpotDetailView(spot: spot)
                }
            }
        }
    }

    // Viser et bilde og åpner fotostedet når det trykkes.
    private func photoButton(_ image: UIImage, spot: PhotoSpot) -> some View {
        Button {
            selectedSpot = spot
        } label: {
            VStack(alignment: .leading) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipped()
                    .cornerRadius(10)

                Text(spot.title)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}
