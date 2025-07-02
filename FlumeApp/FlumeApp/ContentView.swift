//
//  ContentView.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.with.needle")
                }
                .accessibilityLabel("Dashboard Tab")
                .accessibilityHint("Navigates to the main dashboard where you can view Wi-Fi status, SSE messages, REST commands, and a list of experiments.")

            ExperimentView()
                .tabItem {
                    Label("Experiments", systemImage: "flask")
                }
                .accessibilityLabel("Experiments Tab")
                .accessibilityHint("Navigates to the experiments view where you can manage and view details of your experiments.")
        }
    }
}

#Preview {
    ContentView()
}
