import XCTest
import Afterglow

final class AfterglowTests: XCTestCase {

    var weather: WeatherModel?

    func testGetHourly() {
        // Create an expectation
        let expectation = self.expectation(description: "Fetch weather data")

        // Fetch weather data asynchronously
        let instance = APIClient()
        Task {
            do {
                self.weather = try await instance.getWeatherForLocation(43.581552, -79.788750)
                expectation.fulfill() // Fulfill the expectation when the weather data is successfully fetched
            } catch {
                XCTFail("Failed to fetch weather data: \(error)")
            }
        }

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }

        // Ensure weather data is available before running the test
        guard let weather = self.weather else {
            XCTFail("Weather data is nil")
            return
        }

        let predictionsInstance = PredictionsViewModel()
        let result = predictionsInstance.getHourly(weather)
        XCTAssertEqual(predictionsInstance.event, "Sunrise", "Expected event to be 'Sunset' when current time is between sunrise and sunset.")
        
        let resultDate = predictionsInstance.unixToLocalTime(result.dt)
        let resultHour = String(resultDate[resultDate.index(resultDate.startIndex, offsetBy: 11)..<resultDate.index(resultDate.startIndex, offsetBy: 13)])
        
        XCTAssertEqual(resultHour, "06", "Sunrise hour is currently 06")
        
    }
    
    
    func testwestOf() {
        let lat = 43.581552
        let lon = -79.788750
        
        let instance = PredictionsViewModel()
        let newLon = instance.westOf(43.581552,-79.788750)
        
        XCTAssertEqual(newLon, -79.85082407651882, accuracy: 0.01)
    }
    
    func testGetSunsetPrediction() {
        
        let knownSunsets = [
            (70,65,"Good"),
            (75,87,"Poor"),
            (40,60,"Great"),
            (20,57,"Fair"),
            (40,51,"Great"),
            (75,60,"Poor"),
            (100,96,"Poor"),
            (40,70,"Good"),
            (40,96,"Good"),
            (0,64,"Fair"),
            (75,86,"Poor"),
            (40,58,"Great"),
            (75,62,"Poor"),
            (75,70,"Poor"),
            (75,96,"Poor"),
            (1,56,"Fair"),
        ]
        
        let instance = PredictionsViewModel()
        
        for sunset in knownSunsets {
            var quality = instance.getSunsetPrediction(sunset.0, sunset.1)
            XCTAssertEqual(quality.0, sunset.2)
        }
        
    }
}

