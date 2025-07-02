
import XCTest
import CoreData
@testable import FlumeApp

final class ExperimentTests: XCTestCase {

    var persistenceController: PersistenceController!
    var viewContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        viewContext = nil
        try super.tearDownWithError()
    }

    func testCreateExperiment() throws {
        let newExperiment = Experiment(context: viewContext)
        newExperiment.id = UUID()
        newExperiment.name = "Test Experiment"
        newExperiment.notes = "This is a test note."
        newExperiment.startTime = Date()
        newExperiment.status = "Not Run"

        let newConfiguration = ExperimentConfiguration(context: viewContext)
        newConfiguration.ultrasonicSensor1Enabled = true
        newConfiguration.experimentDuration = 120.0
        newConfiguration.dataAcquisitionRate = 0.5

        newExperiment.configuration = newConfiguration

        try viewContext.save()

        let fetchRequest: NSFetchRequest<Experiment> = Experiment.fetchRequest()
        let experiments = try viewContext.fetch(fetchRequest)

        XCTAssertEqual(experiments.count, 1)
        XCTAssertEqual(experiments.first?.name, "Test Experiment")
        XCTAssertEqual(experiments.first?.notes, "This is a test note.")
        XCTAssertEqual(experiments.first?.configuration?.ultrasonicSensor1Enabled, true)
        XCTAssertEqual(experiments.first?.configuration?.experimentDuration, 120.0)
    }

    func testUpdateExperiment() throws {
        // Create an experiment first
        let newExperiment = Experiment(context: viewContext)
        newExperiment.id = UUID()
        newExperiment.name = "Original Name"
        newExperiment.notes = "Original Notes"
        newExperiment.startTime = Date()
        newExperiment.status = "Not Run"

        let newConfiguration = ExperimentConfiguration(context: viewContext)
        newConfiguration.ultrasonicSensor1Enabled = true
        newConfiguration.experimentDuration = 60.0
        newConfiguration.dataAcquisitionRate = 0.1
        newExperiment.configuration = newConfiguration
        try viewContext.save()

        // Now update it
        newExperiment.name = "Updated Name"
        newExperiment.notes = "Updated Notes"
        newExperiment.configuration?.ultrasonicSensor1Enabled = false
        try viewContext.save()

        let fetchRequest: NSFetchRequest<Experiment> = Experiment.fetchRequest()
        let experiments = try viewContext.fetch(fetchRequest)

        XCTAssertEqual(experiments.count, 1)
        XCTAssertEqual(experiments.first?.name, "Updated Name")
        XCTAssertEqual(experiments.first?.notes, "Updated Notes")
        XCTAssertEqual(experiments.first?.configuration?.ultrasonicSensor1Enabled, false)
    }

    func testDeleteExperiment() throws {
        let newExperiment = Experiment(context: viewContext)
        newExperiment.id = UUID()
        newExperiment.name = "Experiment to Delete"
        try viewContext.save()

        let fetchRequest: NSFetchRequest<Experiment> = Experiment.fetchRequest()
        var experiments = try viewContext.fetch(fetchRequest)
        XCTAssertEqual(experiments.count, 1)

        viewContext.delete(newExperiment)
        try viewContext.save()

        experiments = try viewContext.fetch(fetchRequest)
        XCTAssertEqual(experiments.count, 0)
    }
}
