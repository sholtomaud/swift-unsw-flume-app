
import Foundation

enum ExperimentStatus: String, Codable {
    case notRun = "Not Run"
    case running = "Running"
    case success = "Success"
    case failed = "Failed"
}
