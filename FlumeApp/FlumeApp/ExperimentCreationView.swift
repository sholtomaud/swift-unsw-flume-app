
import SwiftUI
import CoreData

struct ExperimentCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var experimentToEdit: Experiment? // Optional experiment to edit

    @State private var experimentName: String = ""
    @State private var experimentNotes: String = ""
    @State private var ultrasonic1Enabled: Bool = true
    @State private var ultrasonic2Enabled: Bool = true
    @State private var ultrasonic3Enabled: Bool = true
    @State private var ultrasonic4Enabled: Bool = true
    @State private var magneticSwitchEnabled: Bool = true
    @State private var experimentDuration: Double = 60.0
    @State private var dataAcquisitionRate: Double = 0.1

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Experiment Details")) {
                    TextField("Experiment Name", text: $experimentName)
                    TextField("Notes", text: $experimentNotes)
                }

                Section(header: Text("Sensor Configuration")) {
                    Toggle("Ultrasonic Sensor 1", isOn: $ultrasonic1Enabled)
                    Toggle("Ultrasonic Sensor 2", isOn: $ultrasonic2Enabled)
                    Toggle("Ultrasonic Sensor 3", isOn: $ultrasonic3Enabled)
                    Toggle("Ultrasonic Sensor 4", isOn: $ultrasonic4Enabled)
                    Toggle("Magnetic Switch", isOn: $magneticSwitchEnabled)
                }

                Section(header: Text("Timing")) {
                    VStack(alignment: .leading) {
                        Text("Duration: \(experimentDuration, format: .number) seconds")
                        Slider(value: $experimentDuration, in: 1.0...3600.0, step: 1.0)
                    }
                    VStack(alignment: .leading) {
                        Text("Data Acquisition Rate: \(dataAcquisitionRate, format: .number) seconds")
                        Slider(value: $dataAcquisitionRate, in: 0.01...1.0, step: 0.01)
                    }
                }
            }
            .navigationTitle(experimentToEdit == nil ? "Create New Experiment" : "Edit Experiment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExperiment()
                    }
                    .disabled(experimentName.isEmpty)
                }
            }
            .onAppear(perform: setupView)
        }
    }

    private func setupView() {
        if let experiment = experimentToEdit {
            experimentName = experiment.name ?? ""
            experimentNotes = experiment.notes ?? ""
            ultrasonic1Enabled = experiment.configuration?.ultrasonicSensor1Enabled ?? true
            ultrasonic2Enabled = experiment.configuration?.ultrasonicSensor2Enabled ?? true
            ultrasonic3Enabled = experiment.configuration?.ultrasonicSensor3Enabled ?? true
            ultrasonic4Enabled = experiment.configuration?.ultrasonicSensor4Enabled ?? true
            magneticSwitchEnabled = experiment.configuration?.magneticSwitchEnabled ?? true
            experimentDuration = experiment.configuration?.experimentDuration ?? 60.0
            dataAcquisitionRate = experiment.configuration?.dataAcquisitionRate ?? 0.1
        }
    }

    private func saveExperiment() {
        let experiment: Experiment
        let configuration: ExperimentConfiguration

        if let existingExperiment = experimentToEdit {
            experiment = existingExperiment
            configuration = existingExperiment.configuration ?? ExperimentConfiguration(context: viewContext)
        } else {
            experiment = Experiment(context: viewContext)
            experiment.id = UUID()
            experiment.startTime = Date()
            experiment.status = "Not Run" // Default status
            configuration = ExperimentConfiguration(context: viewContext)
        }

        experiment.name = experimentName
        experiment.notes = experimentNotes

        configuration.ultrasonicSensor1Enabled = ultrasonic1Enabled
        configuration.ultrasonicSensor2Enabled = ultrasonic2Enabled
        configuration.ultrasonicSensor3Enabled = ultrasonic3Enabled
        configuration.ultrasonicSensor4Enabled = ultrasonic4Enabled
        configuration.magneticSwitchEnabled = magneticSwitchEnabled
        configuration.experimentDuration = experimentDuration
        configuration.dataAcquisitionRate = dataAcquisitionRate

        experiment.configuration = configuration

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    ExperimentCreationView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
