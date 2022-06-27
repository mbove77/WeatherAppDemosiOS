//
//  ContentView.swift
//  WheatherTest
//
//  Created by Resonant Sports on 08/12/2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        VStack {
            if locationManager.location != nil {
                if let weather = weather {
                    WeatherView(weather: weather)
                        .onDisappear(perform: cancelTask)
                } else {
                    ProgressView()
                    
                    .task {
                        loadInfo()
                    }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.704, saturation: 0.815, brightness: 0.255))
        .preferredColorScheme(.dark)
    }
    
    
    private func loadInfo() {
        currentTask = Task {
            async let weatherInfo = callWeatherApi()
            self.weather = await weatherInfo
            await Task.sleep(600_000_000_000)
            guard !Task.isCancelled else { return }
            loadInfo()
        }
    }

    private func cancelTask() {
        print("Disappear")
        currentTask?.cancel()
    }
     
    func callWeatherApi() async -> ResponseBody? {
        do {
            print("Weather API call \(Date())")
            if locationManager.location != nil {
                weather = try await weatherManager.getCurrentWeather(latitude: locationManager.location!.latitude, longitude: locationManager.location!.longitude)
            }
        } catch {
            print("Error getting weather: \(error)")
        }
        return weather
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
