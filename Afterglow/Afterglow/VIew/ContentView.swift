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
            
            Color.orange.opacity(0.6).edgesIgnoringSafeArea(.all)

            LinearGradient(gradient: Gradient(colors: [Color.darkBlue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Cloud cover")
                Text(viewModel.cloudCover)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Visibility")
                Text(viewModel.visibility)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Pressure")
                Text(viewModel.pressure)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Humidity")
                Text(viewModel.humidity)
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
    static let darkOrange = Color(red: 0.8627, green: 0.6588, blue: 0.4235) // Custom dark orange color
}
