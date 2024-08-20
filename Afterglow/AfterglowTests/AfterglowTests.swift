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
}

