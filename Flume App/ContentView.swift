//
//  ContentView.swift
//  Flume App
//
//  Created by Sholto Maud on 25/6/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.with.needle")
                }
            
            Text("Experiments View (Placeholder)")
                .tabItem {
                    Label("Experiments", systemImage: "flask")
                }
            
            Text("Settings View (Placeholder)")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
