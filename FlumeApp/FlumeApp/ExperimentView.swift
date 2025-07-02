
import SwiftUI
import CoreData

struct ExperimentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Experiment.startTime, ascending: true)],
        animation: .default)
    private var experiments: FetchedResults<Experiment>

    var body: some View {
        NavigationView {
            List {
                ForEach(experiments) { experiment in
                    NavigationLink(destination: ExperimentDetailView(experiment: experiment)) {
                        Text(experiment.name ?? "Unnamed Experiment")
                            .accessibilityIdentifier("ExperimentName_\(experiment.id?.uuidString ?? "")")
                    }
                    .accessibilityIdentifier("ExperimentRow_\(experiment.id?.uuidString ?? "")")
                    .accessibilityIdentifier("ExperimentRow_\(experiment.id?.uuidString ?? "")")
                }
            }
            .navigationTitle("Experiments")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExperimentSheet = true }) {
                        Label("Add Experiment", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExperimentSheet) {
                ExperimentCreationView()
            }
        }
    }

    @State private var showingAddExperimentSheet = false
}

#Preview {
    ExperimentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
