<<<<<<< HEAD

import SwiftUI

struct DashboardView: View {
    @State private var sensorValue1: Double = 23.5
    @State private var sensorValue2: Int = 42
    @State private var systemStatus = "ONLINE"
    @State private var batteryLevel: Double = 0.85

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Status header
            HStack {
                Text("SYSTEM STATUS")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(systemStatus)
                    .font(.subheadline)
                    .foregroundColor(systemStatus == "ONLINE" ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(6)
            }
            
            // Sensor readings
            VStack(alignment: .leading, spacing: 12) {
                Text("SENSOR READINGS")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Temperature")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(sensorValue1, specifier: "%.1f")°C")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Pressure")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(sensorValue2) PSI")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            
            // Battery indicator
            VStack(alignment: .leading, spacing: 8) {
                Text("BATTERY")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    ProgressView(value: batteryLevel)
                        .progressViewStyle(LinearProgressViewStyle(tint: batteryLevel > 0.3 ? .green : .red))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                    Text("\(Int(batteryLevel * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(width: 40, alignment: .trailing)
                }
            }
            
            // Control buttons
            VStack(spacing: 12) {
                Text("CONTROLS")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    dashboardButton(title: "SYNC", action: {})
                    dashboardButton(title: "RESET", action: {})
                }
                
                HStack(spacing: 12) {
                    dashboardButton(title: "CALIBRATE", action: {})
                    dashboardButton(title: "EXPORT", action: {})
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
    }
    
    private func dashboardButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.6))
                .cornerRadius(8)
=======
import SwiftUI
import CoreData

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var wifiManager = WiFiManager()
    @StateObject private var sseClient = SSEClient()
    @StateObject private var restClient = RESTClient()
    @StateObject private var dataSyncManager: DataSyncManager
    @State private var restResponse: String = "No REST response yet."
    @State private var showingAddExperimentSheet = false
    @State private var serverURLString: String = "http://localhost:8000"

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)],
        predicate: nil,
        animation: .default)
    private var experiments: FetchedResults<Experiment>

    init() {
        _dataSyncManager = StateObject(wrappedValue: DataSyncManager(viewContext: PersistenceController.shared.container.viewContext))
        _experiments = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], predicate: nil, animation: .default)
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Wi-Fi Status")) {
                    Text("Connected: \(wifiManager.isConnectedToTargetWiFi ? "Yes" : "No")")
                    Text("Target Network: \(wifiManager.targetNetworkName ?? "Not Set")")
                    Button("Set Target Wi-Fi (UNSW.FlumeApp)") {
                        wifiManager.addWiFiNetwork(ssid: "UNSW.FlumeApp", password: "password")
                    }
                }

                Section(header: Text("SSE Status")) {
                    Text("Latest Message: \(sseClient.latestMessage)")
                    Button("Connect to SSE (http://localhost:8080/events)") {
                        sseClient.connect(to: URL(string: "http://localhost:8080/events")!)
                    }
                }

                Section(header: Text("REST Commands")) {
                    Text("REST Response: \(restResponse)")
                    Button("Send Test Command") {
                        restClient.sendSimpleCommand(command: "test", value: "hello") {
                            result in
                            switch result {
                            case .success(let response):
                                self.restResponse = response
                            case .failure(let error):
                                self.restResponse = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }

                Section(header: Text("Experiments")) {
                    ForEach(experiments) { experiment in
                        NavigationLink {
                            ExperimentDetailView(experiment: experiment)
                        } label: {
                            Text(experiment.name ?? "Unnamed Experiment")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }

                Section(header: Text("Data Sync")) {
                    TextField("Server URL", text: $serverURLString)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    Text("Sync Status: \(dataSyncManager.syncStatus)")
                    Button("Sync All Data") {
                        if let url = URL(string: serverURLString) {
                            Task {
                                await dataSyncManager.syncAllData(to: url)
                            }
                        } else {
                            dataSyncManager.syncStatus = "Invalid URL"
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingAddExperimentSheet = true }) {
                        Label("Add Experiment", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                wifiManager.checkWiFiConnectionStatus()
                // SSE connection will be initiated by button for now
            }
            .onDisappear {
                sseClient.disconnect()
            }
            .sheet(isPresented: $showingAddExperimentSheet) {
                ExperimentCreationView()
            }
            Text("Select an experiment")
        }
    }

    private func addExperiment() {
        withAnimation {
            let newExperiment = Experiment(context: viewContext)
            newExperiment.startTime = Date()
            newExperiment.name = "New Experiment \(experiments.count + 1)"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { experiments[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
>>>>>>> 61a933c (feat: Resolve compiler errors and improve code readability)
        }
    }
}

#Preview {
    DashboardView()
<<<<<<< HEAD
}
=======
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
>>>>>>> 61a933c (feat: Resolve compiler errors and improve code readability)
