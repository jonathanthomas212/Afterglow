//
//  LightInfo.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-08-21.
//

import Foundation

struct LightInfoModel: Codable {
    let results: Results
    let status: String
}

struct Results: Codable {
    let date: String
    let sunrise: String
    let sunset: String
    let firstLight: String
    let lastLight: String
    let dawn: String
    let dusk: String
    let solarNoon: String
    let goldenHour: String
    let dayLength: String
    let timezone: String
    let utcOffset: Int

    enum CodingKeys: String, CodingKey {
        case date, sunrise, sunset
        case firstLight = "first_light"
        case lastLight = "last_light"
        case dawn, dusk
        case solarNoon = "solar_noon"
        case goldenHour = "golden_hour"
        case dayLength = "day_length"
        case timezone
        case utcOffset = "utc_offset"
    }
}
