//
//  APIClient.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-07-29.
//

import UIKit


enum APIError: Error {
    case invalidURL
    case badResponse
    case decodingError
    case misc
}


class APIClient: NSObject {
    
    
    //generic get request, takes url and returns specified model
    func fetchData <T:Codable>(_ url: String) async throws -> T {
        guard let URL = URL(string: url) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        // Print raw data for debugging
//        if let rawDataString = String(data: data, encoding: .utf8) {
//            print("Raw data:", rawDataString)
//        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.badResponse
        }
        
        //decode response
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            print("successfully retrieved data")
            return decodedResponse
        } catch {
            print(error)
            throw APIError.decodingError
        }
        
        
    }
    
    
    //build url with location and call fetchData
    func getWeatherForLocation(_ lat:Double, _ lon:Double) async throws -> WeatherModel {
        
        //build url
        let baseurl = "https://api.openweathermap.org/data/3.0/onecall?"
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "SECRET") as? String else {
            throw APIError.misc
        }
        
        let url = baseurl + "lat=" + String(lat) + "&lon=" + String(lon) + "&appid=" + apiKey + "&exclude=minutely,daily,alerts"
        
        
        //call get request func
        let weather:WeatherModel = try await fetchData(url)
        return weather
        
    }
    
    
    
    func getLightInfoForLocation(_ lat:Double, _ lon:Double) async throws -> LightInfoModel {
        
        //build url
        let baseurl = "https://api.sunrisesunset.io/json?"
        
        
        let url = baseurl + "lat=" + String(lat) + "&lng=" + String(lon)
        
        
        //call get request func
        let light:LightInfoModel = try await fetchData(url)
        
        if light.status == "OK" {
            return light
        } else {
            throw APIError.badResponse
        }
        
    }
    
}
