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
        }
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
        }
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}