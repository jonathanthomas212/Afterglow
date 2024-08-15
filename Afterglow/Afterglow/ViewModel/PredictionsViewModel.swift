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
    
    func getPredictions() async {
        let apiClient = APIClient()
        
        do {
            //hardcoded lon, lat for now
            let result = try await apiClient.getWeatherForLocation(43.581552,-79.788750)
            DispatchQueue.main.async {
                self.cloudCover = String(result.current.clouds)
                self.visibility = String(result.current.visibility)
                self.pressure = String(result.current.pressure)
                self.humidity = String(result.current.humidity)
                
            }
            
        } catch {
            DispatchQueue.main.async {
                self.cloudCover = "Failed to fetch weather data"
            }
            
        }
    }
    
}
