//
//  WeatherView.swift
//  WheatherTest
//
//  Created by Resonant Sports on 11/12/2021.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    var weatherManager = WeatherManager()
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack() {
                Spacer()
                    .frame(height: 15)
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.day().month().hour().minute())) ")
                        .fontWeight(.light)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    VStack() {
                        HStack() {
                            VStack(spacing: 10) {
                                AsyncImage(url: weatherManager.getIcon(iconID: weather.weather[0].icon)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 75)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                
                                Text(weather.weather[0].description.capitalizingFirstLetter())
                                    
                            }
                            .padding(.leading, 20)
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            
                            Text(weather.main.feelsLike.roundDouble() + "˚")
                                .font(.system(size: 90))
                                .fontWeight(.bold)
                                .padding()
                        }
                        .background(Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.5))
                        .cornerRadius(20, corners: [.topRight, .topLeft, .bottomLeft, .bottomRight])
                        
                        Spacer()
                            .frame(height: 120)
                        
                        AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: nil)
                            } placeholder: {
                                ProgressView()
                            }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack() {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Weather now")
                        .bold()
                        .padding(.bottom)
                    
                    HStack() {
                        WeatherRow(logo: "thermometer", name: "Min Temp", value: " \(weather.main.tempMin.roundDouble())˚")
                        
                        Spacer()
                        
                        WeatherRow(logo: "thermometer", name: "Max Temp", value: " \(weather.main.tempMax.roundDouble())˚")
                    }
                    
                    HStack() {
                        WeatherRow(logo: "wind", name: "Wind Speed", value: " \(weather.wind.speed.roundDouble())m/s")
                        
                        Spacer()
                        
                        WeatherRow(logo: "humidity", name: "Humedity", value: " \(weather.main.humidity.roundDouble())%")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.704, saturation: 0.815, brightness: 0.255))
                .background(.white)
                .cornerRadius(20, corners: [.topRight, .topLeft])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(AsyncImage(url: weatherManager.getDayOrNightBackground(sunSetTime: weather.sys.sunset)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } placeholder: {
            ProgressView()
        })
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
