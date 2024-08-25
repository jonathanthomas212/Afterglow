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
    @Published var goldenHour: String = "Loading..."
    
    
    
    func getPredictions() async {
        
        //fetch weather data
        let apiClient = APIClient()
        
        //Calculate west of location, hardcoded lat/lon for now
        let lat = 43.581552
        let lon = -79.788750
        let newLon = self.westOf(lat, lon)
        
        do {
            
            //fetch golden/blue hour times
            let light = try await apiClient.getLightInfoForLocation(lat,newLon)
            
            //fetch weather data
            let result = try await apiClient.getWeatherForLocation(lat, newLon)
            
            //get golden/blue hour times
            let lightTimes = self.getGoldenBlueHourTimes(light)
            print("light times: ", lightTimes)
            
            
            
            //ui updates
            DispatchQueue.main.async {
                
                //get forecast for sunset/sunrise hour (ui update in function)
                let hourlyForecast = self.getHourly(result)
                print("forecast for: ", self.unixToLocalTime(hourlyForecast.dt))
                print(hourlyForecast)
                
                //temp labels
                self.cloudCover = String(hourlyForecast.clouds)
                self.visibility = String(hourlyForecast.visibility ?? 0) //for some reason the api sometimes doesnt include visibility??
                self.pressure = String(hourlyForecast.pressure)
                self.humidity = String(hourlyForecast.humidity)
                self.goldenHour = lightTimes["goldenHourStart"]!
            }
            
        } catch {
            DispatchQueue.main.async {
                print(error)
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
    func getGoldenBlueHourTimes(_ lightInfo: LightInfoModel) -> [String:String] {
        
        var times = [String:String]()
        var twilight: Date
        var goldenHourStart: Date
        var goldenHourEnd: Date
        var blueHourStart: Date
        var blueHourEnd: Date
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "hh:mm:ss a"
        
        if self.event == "Sunset" {
            
            goldenHourStart = inputFormatter.date(from: lightInfo.results.goldenHour)!
            goldenHourEnd = inputFormatter.date(from: lightInfo.results.sunset)!
            twilight = inputFormatter.date(from: lightInfo.results.sunset)!
            blueHourStart = inputFormatter.date(from: lightInfo.results.sunset)!
            blueHourEnd = inputFormatter.date(from: lightInfo.results.dusk)!.addingTimeInterval(-10 * 60)
            
        } else { //sunrise
            
            blueHourStart = inputFormatter.date(from: lightInfo.results.dawn)!.addingTimeInterval(10 * 60)
            blueHourEnd = inputFormatter.date(from: lightInfo.results.sunrise)!
            twilight = inputFormatter.date(from: lightInfo.results.sunrise)!
            goldenHourStart = inputFormatter.date(from: lightInfo.results.sunrise)!
            
            let goldenHourDuration = inputFormatter.date(from: lightInfo.results.sunset)!.timeIntervalSince(inputFormatter.date(from: lightInfo.results.goldenHour)!)
            goldenHourEnd = inputFormatter.date(from: lightInfo.results.sunrise)!.addingTimeInterval(goldenHourDuration)
        }
        
        //format dates as strings and load in dictionary
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
           
        times["twilight"] = outputFormatter.string(from: twilight)
        times["goldenHourStart"] = outputFormatter.string(from: goldenHourStart)
        times["goldenHourEnd"] = outputFormatter.string(from: goldenHourEnd)
        times["blueHourStart"] = outputFormatter.string(from: blueHourStart)
        times["blueHourEnd"] = outputFormatter.string(from: blueHourEnd)
        
        return times
    }
    
    
    
    func getSunsetPrediction() {
        
    }
    
    
    
    //util function mostly used for debugging
    func unixToLocalTime(_ unixTime: Int) -> String {
        
        let utc = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localTime = dateFormatter.string(from: utc)
        
        return localTime
    }
    
    
    //set coordinates x km west to foucs on clouds in the horizon
    func westOf(_ latitude: Double, _ longitude: Double) -> Double {
        let earthRadius = 6371.0 // Earth's radius in kilometers
        let distance = 4.0 // Distance in kilometers
        
        // Convert latitude from degrees to radians
        let latRad = latitude * .pi / 180
        
        // Calculate the change in longitude
        let deltaLon = distance / (earthRadius * cos(latRad))
        
        // Subtract deltaLon to get the new longitude west
        let newLongitude = longitude - (deltaLon * 180 / .pi)
        
        return newLongitude
    }
}
