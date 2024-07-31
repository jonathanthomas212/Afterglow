//
//  ContentView.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-07-17.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            Color.orange.opacity(0.6).edgesIgnoringSafeArea(.all)

            LinearGradient(gradient: Gradient(colors: [Color.darkBlue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Cloud cover")
                Text("???")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Visibility")
                Text("???")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Pressure")
                Text("???")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Humidity")
                Text("???")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            .foregroundColor(Color.white)
        .padding()
        }.onAppear {
            Task {
                let apiClient = APIClient()
                //hardcoded lon, lat for now
                let result = try await apiClient.getWeatherForLocation(43.581552,-79.788750)
            }
        }
    }
}

#Preview {
    ContentView()
}

extension Color {
    static let darkBlue = Color(red: 0.1, green: 0.1, blue: 0.5) // Custom dark blue color
}
