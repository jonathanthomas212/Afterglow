//
//  Weather.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-07-29.
//

import Foundation

// Top-level structure
struct WeatherModel: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly
    }
}

// Current weather structure
struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let rain: Precipitation?
    let snow: Precipitation?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, rain, snow
    }
}

// Precipitation structure
struct Precipitation: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

// Hourly weather structure
struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let pop: Double
    let rain: Precipitation?
    let snow: Precipitation?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop, rain, snow
    }
}

// Temperature structure
struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

// Feels like temperature structure
struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

// Weather structure
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// Weather alert structure
struct WeatherAlert: Codable {
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let description: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end, description, tags
    }
}



//struct Weather: Identifiable, Codable {
//    struct Coordinate: Codable {
//        let lon: Double
//        let lat: Double
//    }
//    
//    struct WeatherCondition: Codable {
//        let id: Int
//        let main: String
//        let description: String
//        let icon: String
//    }
//    
//    struct MainInfo: Codable {
//        let temp: Double
//        let feels_like: Double
//        let temp_min: Double
//        let temp_max: Double
//        let pressure: Int
//        let humidity: Int
//        let sea_level: Int?
//        let grnd_level: Int?
//    }
//    
//    struct Wind: Codable {
//        let speed: Double
//        let deg: Int
//        let gust: Double?
//    }
//    
//    struct Rain: Codable {
//        let oneHour: Double
//        
//        enum CodingKeys: String, CodingKey {
//            case oneHour = "1h"
//        }
//    }
//    
//    struct Clouds: Codable {
//        let all: Int
//    }
//    
//    struct System: Codable {
//        let type: Int?
//        let id: Int?
//        let country: String?
//        let sunrise: Int?
//        let sunset: Int?
//    }
//    
//    let coord: Coordinate
//    let weather: [WeatherCondition]
//    let base: String
//    let main: MainInfo
//    let visibility: Int
//    let wind: Wind
//    let rain: Rain?
//    let clouds: Clouds
//    let dt: Int
//    let sys: System
//    let timezone: Int
//    let id: Int
//    let name: String
//    let cod: Int
//}

