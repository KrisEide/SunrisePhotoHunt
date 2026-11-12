
import CoreLocation
import Observation

@Observable
final class UserLocationRepository: NSObject, CLLocationManagerDelegate {

    private(set) var currentLocation: CLLocation?
    private(set) var authorizationStatus: CLAuthorizationStatus

    @ObservationIgnored private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
    }

    // Ber om tilgang til brukerens posisjon.
    func requestAuthorization() {
        print("Location permission: \(locationManager.authorizationStatus)")
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse ||
                  authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    // Oppdaterer posisjonen når vi får nye koordinater.
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        currentLocation = locations.last
        print("Location received: \(String(describing: currentLocation))")
    }

    // Starter lokasjonsoppdateringer når brukeren gir tillatelse.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if authorizationStatus == .authorizedWhenInUse ||
           authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
            currentLocation = nil
        }
    }
    
    // Viser feil dersom posisjonen ikke kan hentes.
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error)")
    }
}









