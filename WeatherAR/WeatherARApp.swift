//
//  WeatherARApp.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 06/08/23.
//

import SwiftUI

@main
struct WeatherARApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ARViewController.shared)
        }
    }
}
