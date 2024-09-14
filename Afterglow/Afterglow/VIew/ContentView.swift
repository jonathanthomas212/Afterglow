//
//  ContentView.swift
//  Afterglow
//
//  Created by Jonathan Thomas on 2024-07-17.
//

import SwiftUI

struct ContentView: View {
    
    //auto update published variables from view model
    @StateObject private var viewModel = PredictionsViewModel()
    
    
    var body: some View {
        
        ZStack(alignment: .top){
            Color.lightOrange.edgesIgnoringSafeArea(.all)

            LinearGradient(gradient: Gradient(colors: [Color.darkBlue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                //location
                HStack{
                    Image(systemName: "location.fill")
                    Text("Current Location")
                }
                Spacer()
                
                //sunset quality graphic
                if (viewModel.event == "Sunrise") {
                    Image(systemName: "sunrise")
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "sunset")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
                //sunset quality info
                Spacer()
                Text(viewModel.event)
                Text(viewModel.sunsetQuality.0)
                    .font(.largeTitle)
                    .bold()
                Text(viewModel.sunsetQuality.1)
                Spacer()
                Text(viewModel.sunsetQuality.2)
                    .multilineTextAlignment(.center)
                Spacer()
                
                //temp info for debugging sunset prediction
                HStack {
                    Text("Cloud Cover:")
                    Text(viewModel.cloudCover)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("Humidity:")
                    Text(viewModel.humidity)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                
            }
            .foregroundColor(Color.white)
        .padding()
        }.onAppear {
            Task {
                await viewModel.getPredictions()
            }
        }
    }
}

#Preview {
    ContentView()
}

extension Color {
    static let darkBlue = Color(red: 0.1, green: 0.1, blue: 0.5) // Custom dark blue color
    static let lightOrange = Color(red: 1.0, green: 0.768, blue: 0.4) // Custom light orange color
}
