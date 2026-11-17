
import Foundation

struct SunriseService {

    func fetchSunTimes(latitude: Double, longitude: Double, date: Date) async throws -> SunriseResponse {

        // Gjør datoen om til formatet API-et forventer.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        // Lager URL med fotostedets koordinater og dato.
        let urlString = "https://api.sunrise-sunset.org/v2?lat=\(latitude)&lng=\(longitude)&date=\(dateString)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        // Henter data fra API-et.
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Gjør JSON-dataene om til en Swift-modell.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(SunriseResponse.self, from: data)
    }
}

