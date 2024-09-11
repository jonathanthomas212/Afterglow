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
                Spacer()
                Text("Event")
                Text(viewModel.event)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Cloud cover")
                Text(viewModel.cloudCover)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Humidity")
                Text(viewModel.humidity)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Sunset Quality")
                Text(viewModel.sunsetQuality)
                    .font(.title)
                Text(viewModel.confidence)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
