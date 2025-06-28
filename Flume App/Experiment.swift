
import Foundation

enum ExperimentStatus: String, Codable {
    case notRun = "Not Run"
    case running = "Running"
    case success = "Success"
    case failed = "Failed"
}

struct Experiment: Identifiable, Codable {
    let id: UUID
    var name: String
    var configuration: ExperimentConfiguration
    var status: ExperimentStatus
    var videoPath: URL?
    var notes: String
    var startTime: Date?
    var endTime: Date?
    var sensorData: [SensorDataPoint] // For historical data
    var metadata: ExperimentMetadata?

    init(id: UUID = UUID(), name: String, configuration: ExperimentConfiguration, status: ExperimentStatus = .notRun, videoPath: URL? = nil, notes: String = "", startTime: Date? = nil, endTime: Date? = nil, sensorData: [SensorDataPoint] = [], metadata: ExperimentMetadata? = nil) {
        self.id = id
        self.name = name
        self.configuration = configuration
        self.status = status
        self.videoPath = videoPath
        self.notes = notes
        self.startTime = startTime
        self.endTime = endTime
        self.sensorData = sensorData
        self.metadata = metadata
    }
}

struct ExperimentConfiguration: Codable {
    var ultrasonicSensor1Enabled: Bool
    var ultrasonicSensor2Enabled: Bool
    var ultrasonicSensor3Enabled: Bool
    var ultrasonicSensor4Enabled: Bool
    var magneticSwitchEnabled: Bool
    var experimentDuration: TimeInterval // in seconds
    var dataAcquisitionRate: TimeInterval // in seconds (e.g., 0.1 for 100ms)
    // Add other configurable parameters as needed
}

struct SensorDataPoint: Codable {
    let timestamp: Date
    let ultrasonic1: Double?
    let ultrasonic2: Double?
    let ultrasonic3: Double?
    let ultrasonic4: Double?
    let magneticSwitch: Bool?
}

struct ExperimentMetadata: Codable {
    var location: String?
    var experimenter: String?
    var deviceID: String?
    // Add other metadata fields as needed
}
