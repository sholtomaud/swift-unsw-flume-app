import SwiftUI
import CoreData

struct ExperimentDetailView: View {
    @ObservedObject var experiment: Experiment
    @EnvironmentObject var sseClient: SSEClient
    @EnvironmentObject var restClient: RESTClient
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingEditExperimentSheet = false
    @State private var showingVideoRecorderSheet = false

    var ultrasonic1Status: String {
        experiment.configuration?.ultrasonicSensor1Enabled ?? false ? "Yes" : "No"
    }

    var experimentDurationText: String {
        "\(experiment.configuration?.experimentDuration ?? 0)"
    }

    func magneticSwitchStatus(for dataPoint: SensorDataPoint) -> String {
        dataPoint.magneticSwitch ? "On" : "Off"
    }

    func ultrasonic1Text(for dataPoint: SensorDataPoint) -> String {
        String(format: "%.2f", dataPoint.ultrasonic1)
    }

    var isStopButtonDisabled: Bool {
        experiment.status == "Running" && experiment.endTime != nil
    }

    var buttonStyleForExperiment: AnyButtonStyle {
        if experiment.status == "Running" {
            return AnyButtonStyle(DestructiveButtonStyle())
        } else {
            return AnyButtonStyle(PrimaryButtonStyle())
        }
    }

    private func sortedSensorDataPoints(from sensorData: NSSet) -> [SensorDataPoint] {
        sensorData.allObjects.compactMap { $0 as? SensorDataPoint }.sorted(by: { $0.timestamp ?? Date.distantPast < $1.timestamp ?? Date.distantPast })
    }

    var body: some View {
        Form {
            Section(header: Text("Experiment Details")) {
                Text("Name: \(experiment.name ?? "N/A")")
                Text("Status: \(experiment.status ?? "N/A")")
                Text("Start Time: \(experiment.startTime ?? Date(), formatter: itemFormatter)")
                Text("End Time: \(experiment.endTime ?? Date(), formatter: itemFormatter)")
                Text("Notes: \(experiment.notes ?? "N/A")")
            }

            Section(header: Text("Configuration")) {
                Text("Ultrasonic 1 Enabled: \(ultrasonic1Status)")
                Text("Experiment Duration: \(experimentDurationText) seconds")
            }

            Section(header: Text("Experiment Control")) {
                Button(action: {
                    if experiment.status == "Running" {
                        stopExperiment()
                    } else {
                        startExperiment()
                    }
                }) {
                    Text(experiment.status == "Running" ? "Stop Experiment" : "Start Experiment")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(buttonStyleForExperiment)
                .disabled(isStopButtonDisabled) // Disable stop if already ended

            }

            Section(header: Text("Sensor Data")) {
                Text("Latest SSE Message: \(sseClient.latestMessage)")
                Button("Connect to SSE (http://localhost:8080/events)") {
                    sseClient.connect(to: URL(string: "http://localhost:8080/events")!)
                }

                Button("Record Video") {
                    showingVideoRecorderSheet = true
                }
                .sheet(isPresented: $showingVideoRecorderSheet) {
                    VideoRecorderView(onVideoRecorded: { videoURL in
                        experiment.videoPath = videoURL.absoluteString
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    })
                }

                if let sensorData = experiment.sensorData as? NSSet {
                    ForEach(sortedSensorDataPoints(from: sensorData)) { dataPoint in
                        VStack(alignment: .leading) {
                            Text("Timestamp: \(dataPoint.timestamp ?? Date(), formatter: itemFormatter)")
                            Text("Ultrasonic 1: \(ultrasonic1Text(for: dataPoint))")
                            Text("Magnetic Switch: \(magneticSwitchStatus(for: dataPoint))")
                        }
                    }
                }
            }
        }
        .navigationTitle(experiment.name ?? "Experiment Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditExperimentSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditExperimentSheet) {
            ExperimentCreationView(experimentToEdit: experiment)
        }
    }

    private func startExperiment() {
        restClient.sendSimpleCommand(command: "start_experiment", value: experiment.id?.uuidString ?? "") { result in
            switch result {
            case .success(let response):
                print("Start experiment response: \(response)")
                experiment.status = "Running"
                experiment.startTime = Date()
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            case .failure(let error):
                print("Error starting experiment: \(error.localizedDescription)")
            }
        }
    }

    private func stopExperiment() {
        restClient.sendSimpleCommand(command: "stop_experiment", value: experiment.id?.uuidString ?? "") { result in
            switch result {
            case .success(let response):
                print("Stop experiment response: \(response)")
                experiment.status = "Completed"
                experiment.endTime = Date()
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            case .failure(let error):
                print("Error stopping experiment: \(error.localizedDescription)")
            }
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}