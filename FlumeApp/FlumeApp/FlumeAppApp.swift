//
//  FlumeAppApp.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//

import SwiftUI

@main
struct FlumeAppApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var sseClient = SSEClient()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(sseClient)
        }
    }
}
