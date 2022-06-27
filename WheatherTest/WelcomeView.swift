//
//  WelcomeView.swift
//  WheatherTest
//
//  Created by Resonant Sports on 08/12/2021.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            VStack(spacing: 20 ) {
                Text("Welcome to WatherApp.")
                    .bold()
                    .font(.title)
                Text("Please share your current location to get the wather in your area.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
