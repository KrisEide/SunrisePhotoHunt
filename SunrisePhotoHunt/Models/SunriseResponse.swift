
import Foundation

struct SunriseResponse: Decodable {

    let sunrise: Date?
    let sunset: Date?
    let tzid: String

    let golden_hour: LightPeriods?
    let blue_hour: LightPeriods?
}

// Inneholder lysperiodene morgen og kveld.
struct LightPeriods: Decodable {
    let morning: LightPeriod?
    let evening: LightPeriod?
}

// Inneholder start- og sluttidspunkt for én periode.
struct LightPeriod: Decodable {
    let begin: Date?
    let end: Date?
}







