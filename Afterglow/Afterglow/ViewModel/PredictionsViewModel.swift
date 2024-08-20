//
//  PredictionsViewModel.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-08-14.
//

import Foundation

class PredictionsViewModel: ObservableObject {
    
    //any changes auto refreshes views
    @Published var cloudCover: String = "Loading..."
    @Published var visibility: String = "Loading..."
    @Published var pressure: String = "Loading..."
    @Published var humidity: String = "Loading..."
    @Published var event: String = "Loading..." //sunset or sunrise
    
    
    
    func getPredictions() async {
        
        //fetch weather data
        let apiClient = APIClient()
        
        do {
            //Calculate west of location, hardcoded lat/lon for now
            let lat = 43.581552
            let lon = -79.788750
            let newLon = self.westOf(lat, lon)
            
            
            let result = try await apiClient.getWeatherForLocation(lat, newLon)
            DispatchQueue.main.async {
                
                //get forecast for sunset/sunrise hour
                let hourlyForecast = self.getHourly(result)
                print("forecast for: ", self.unixToLocalTime(hourlyForecast.dt))
                print(hourlyForecast)
                
                //temp labels
                self.cloudCover = String(hourlyForecast.clouds)
                self.visibility = String(hourlyForecast.visibility ?? 0) //for some reason the api sometimes doesnt include visibility??
                self.pressure = String(hourlyForecast.pressure)
                self.humidity = String(hourlyForecast.humidity)
            }
            
        } catch {
            DispatchQueue.main.async {
                self.cloudCover = "Failed to fetch weather data"
            }
            
        }
    }
    
    
    
    //determine whether sunset or sunrise and return hourly forecast for that specific hour
    func getHourly(_ weather: WeatherModel) -> HourlyWeather{
        
        let currentDate = Date()
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(weather.current.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(weather.current.sunset))
        
        var selectedHour: Int
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        //determine whether sunrise or sunset and extract hour
        if (sunriseDate < currentDate) &&  (sunsetDate > currentDate) {
            self.event = "Sunset"
            selectedHour = calendar.component(.hour, from: sunsetDate)
        } else {
            self.event = "Sunrise"
            selectedHour = calendar.component(.hour, from: sunriseDate)
        }
        
        //search hourly forecast and return for selected hour
        for hour in weather.hourly {
            
            let dateUTC = Date(timeIntervalSince1970: TimeInterval(hour.dt))
            let dateHour = calendar.component(.hour, from: dateUTC)
            
            if dateHour == selectedHour {
                return hour
            }
        }
        return weather.hourly[0]
        
    }
    
    
    
    //calculate golden and blue hour and set the labels
    func getGoldenBlueHourTimes() {
        
    }
    
    func getSunsetPrediction() {
        
    }
    
    
    
    func unixToLocalTime(_ unixTime: Int) -> String {
        
        let utc = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localTime = dateFormatter.string(from: utc)
        
        return localTime
    }
    
    
    
    func westOf(_ latitude: Double, _ longitude: Double) -> Double {
        let earthRadius = 6371.0 // Earth's radius in kilometers
        let distance = 4.0 // Distance in kilometers
        
        // Convert latitude from degrees to radians
        let latRad = latitude * .pi / 180
        
        // Calculate the change in longitude
        let deltaLon = distance / (earthRadius * cos(latRad))
        
        // Subtract deltaLon to get the new longitude 5 km west
        let newLongitude = longitude - (deltaLon * 180 / .pi)
        
        return newLongitude
    }
}
