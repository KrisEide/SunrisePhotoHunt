
import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct MapView: View {

    // Startposisjonen til kartet er Oslo sentrum.
    private static let centerPosition = CLLocationCoordinate2D(
        latitude: 59.9139,
        longitude: 10.7522
    )

    // Holder styr på kartets kameraposisjon.
    @State private var camera: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: centerPosition,
            distance: 5000
        )
    )

    // Bestemmer om skjemaet for et nytt fotosted skal vises.
    @State private var isShowingAddPhotoSpot = false

    // Lagrer koordinatene til punktet midt på kartet.
    @State private var selectedCoordinate = MapView.centerPosition

    // Holder på fotostedet brukeren har trykket på.
    @State private var selectedSpot: PhotoSpot?

    // Gir tilgang til SwiftData.
    @Environment(\.modelContext) private var modelContext

    // Henter lagrede fotosteder fra SwiftData.
    @Query private var photoSpots: [PhotoSpot]
    
    @Environment(UserLocationRepository.self)
    private var userLocationRepository

    @State private var shouldCenterOnUser = false
    @State private var showLocationAlert = false

    var body: some View {
        ZStack(alignment: .bottom) {

            // Viser kartet med brukerens egne fotosteder.
            Map(position: $camera) {
                
                ForEach(photoSpots) { spot in
                    Annotation(
                        spot.title,
                        coordinate: CLLocationCoordinate2D(
                            latitude: spot.latitude,
                            longitude: spot.longitude
                        )
                    ) {
                        // Åpner detaljvisningen når brukeren trykker på markøren.
                        Button {
                            selectedSpot = spot
                        } label: {
                            
                            Image(systemName: "camera.fill")
                                .padding(8)
                                .background(
                                    spot.isPhotographed ? .green : .orange,
                                    in: Circle()
                                )
                                .foregroundStyle(.white)

                        }
                        .buttonStyle(.plain)
                    }
                }
                
                
                // Viser brukerens posisjon som en blå prikk.
                if let location = userLocationRepository.currentLocation {
                    Annotation("My Location", coordinate: location.coordinate) {
                        Circle()
                            .fill(.blue)
                            .frame(width: 16, height: 16)
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 3)
                            }
                    }
                }


                
            }
            .mapStyle(.standard(
                emphasis: .muted,
                pointsOfInterest: .all
            ))
            .ignoresSafeArea()
            

            // Oppdaterer valgt posisjon når kartet flyttes.
            .onMapCameraChange(frequency: .continuous) { context in
                selectedCoordinate = context.region.center
            }
            
            .onChange(of: userLocationRepository.currentLocation?.timestamp) { _, _ in
                if shouldCenterOnUser {
                    centerOnUser()
                }
            }

            // Viser et kryss midt på kartet.
            .overlay {
                Image(systemName: "plus")
                    .font(.title.bold())
                    .foregroundStyle(.orange)
                    .allowsHitTesting(false)
            }

            
           
            // Knapp for å opprette et fotosted på valgt kartposisjon.
            Button {
                isShowingAddPhotoSpot = true
            } label: {
                Label("Add Photo Spot", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 16)
            
            
            // Knapp for å finne brukerens posisjon.
            Button {
                if userLocationRepository.authorizationStatus == .denied ||
                   userLocationRepository.authorizationStatus == .restricted {
                    showLocationAlert = true
                } else {
                    shouldCenterOnUser = true
                    userLocationRepository.requestAuthorization()
                    centerOnUser()
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.title3)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 16)
            .padding(.bottom, 80)




        } // Avslutter ZStack
        

        // Åpner skjemaet for å opprette et fotosted.
        
        .sheet(isPresented: $isShowingAddPhotoSpot) {
            AddPhotoSpotView(coordinate: $selectedCoordinate) { newSpot in

                // Legger fotostedet til i SwiftData.
                modelContext.insert(newSpot)

                do {
                    try modelContext.save()

                    print("Saved: \(newSpot.title)")
                    print("Coordinates: \(newSpot.latitude), \(newSpot.longitude)")

                    

                } catch {
                    print("Error saving photo spot: \(error)")
                }
            }
        }


        // Åpner detaljvisningen for valgt fotosted.
        .sheet(item: $selectedSpot) { spot in
            NavigationStack {
                PhotoSpotDetailView(spot: spot)
            }
        }
        
        
        .alert("Location Unavailable", isPresented: $showLocationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Allow location access in Settings to see your position.")
        }


    } // Avslutter body
    
    
    // Flytter kartet til brukerens posisjon.
    private func centerOnUser() {
        guard let location = userLocationRepository.currentLocation else {
            return
        }

        withAnimation {
            camera = .camera(
                MapCamera(centerCoordinate: location.coordinate, distance: 5000)
            )
        }

        shouldCenterOnUser = false
    }

} // Avslutter MapView

#Preview {
    MapView()
        .environment(
            UserLocationRepository(locationManager: CLLocationManager())
        )
}
