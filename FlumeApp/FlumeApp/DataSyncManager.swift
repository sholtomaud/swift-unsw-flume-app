import Foundation
import CoreData
import CryptoKit

class DataSyncManager: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @Published var syncStatus: String = "Idle"

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func syncAllData(to serverURL: URL) async {
        syncStatus = "Syncing..."
        let fetchRequest: NSFetchRequest<Experiment> = Experiment.fetchRequest()

        do {
            let experiments = try viewContext.fetch(fetchRequest)
            for experiment in experiments {
                await syncExperiment(experiment, to: serverURL)
            }
            syncStatus = "Sync Complete!"
        } catch {
            syncStatus = "Sync Failed: \(error.localizedDescription)"
            print("Failed to fetch experiments: \(error)")
        }
    }

    private func syncExperiment(_ experiment: Experiment, to serverURL: URL) async {
        // Sync Experiment details
        await sendExperimentDetails(experiment, to: serverURL)

        // Sync Video (if exists)
        if let videoPath = experiment.videoPath, let videoURL = URL(string: videoPath) {
            await sendFile(at: videoURL, type: "video", for: experiment, to: serverURL)
        }

        // Sync Sensor Data (if exists)
        if let sensorData = experiment.sensorData {
            await sendSensorData([sensorData], for: experiment, to: serverURL)
        }

        // Sync Metadata (if exists)
        if let metadata = experiment.metadata {
            await sendMetadata(metadata, for: experiment, to: serverURL)
        }
    }

    private func sendExperimentDetails(_ experiment: Experiment, to serverURL: URL) async {
        guard let experimentID = experiment.id?.uuidString else { return }
        let details: [String: Any?] = [
            "id": experimentID,
            "name": experiment.name,
            "notes": experiment.notes,
            "startTime": experiment.startTime?.ISO8601Format(),
            "endTime": experiment.endTime?.ISO8601Format(),
            "status": experiment.status,
            "configuration": [
                "ultrasonicSensor1Enabled": experiment.configuration?.ultrasonicSensor1Enabled as Any,
                "ultrasonicSensor2Enabled": experiment.configuration?.ultrasonicSensor2Enabled as Any,
                "ultrasonicSensor3Enabled": experiment.configuration?.ultrasonicSensor3Enabled as Any,
                "ultrasonicSensor4Enabled": experiment.configuration?.ultrasonicSensor4Enabled as Any,
                "magneticSwitchEnabled": experiment.configuration?.magneticSwitchEnabled as Any,
                "experimentDuration": experiment.configuration?.experimentDuration as Any,
                "dataAcquisitionRate": experiment.configuration?.dataAcquisitionRate as Any
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: details.compactMapValues { $0 })
            var request = URLRequest(url: serverURL.appendingPathComponent("experiment_details"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully synced experiment details for \(experiment.name ?? "")")
            } else {
                print("Failed to sync experiment details for \(experiment.name ?? ""): \(response)")
            }
        } catch {
            print("Error syncing experiment details for \(experiment.name ?? ""): \(error)")
        }
    }

    private func sendFile(at fileURL: URL, type: String, for experiment: Experiment, to serverURL: URL) async {
        guard let experimentID = experiment.id?.uuidString else { return }
        do {
            let fileData = try Data(contentsOf: fileURL)
            let checksum = Insecure.MD5.hash(data: fileData).map { String(format: "%02hhx", $0) }.joined()

            var request = URLRequest(url: serverURL.appendingPathComponent("file_upload"))
            request.httpMethod = "POST"

            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"experiment_id\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(experimentID)\r\n".data(using: .utf8)!)

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file_type\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(type)\r\n".data(using: .utf8)!)

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"checksum\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(checksum)\r\n".data(using: .utf8)!)

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully synced \(type) for \(experiment.name ?? "")")
            } else {
                print("Failed to sync \(type) for \(experiment.name ?? ""): \(response)")
            }
        } catch {
            print("Error syncing \(type) for \(experiment.name ?? ""): \(error))")
        }
    }

    private func sendSensorData(_ sensorDataPoints: [SensorDataPoint], for experiment: Experiment, to serverURL: URL) async {
        guard let experimentID = experiment.id?.uuidString else { return }
        let dataPoints = sensorDataPoints.map {
            [
                "timestamp": $0.timestamp?.ISO8601Format() as Any,
                "ultrasonic1": $0.ultrasonic1,
                "ultrasonic2": $0.ultrasonic2,
                "ultrasonic3": $0.ultrasonic3,
                "ultrasonic4": $0.ultrasonic4,
                "magneticSwitch": $0.magneticSwitch
            ]
        }

        let payload: [String: Any] = [
            "experiment_id": experimentID,
            "sensor_data": dataPoints
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload)
            var request = URLRequest(url: serverURL.appendingPathComponent("sensor_data"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully synced sensor data for \(experiment.name ?? "")")
            } else {
                print("Failed to sync sensor data for \(experiment.name ?? ""): \(response)")
            }
        } catch {
            print("Error syncing sensor data for \(experiment.name ?? ""): \(error)")
        }
    }

    private func sendMetadata(_ metadata: ExperimentMetadata, for experiment: Experiment, to serverURL: URL) async {
        guard let experimentID = experiment.id?.uuidString else { return }
        let metadataDetails: [String: Any?] = [
            "experiment_id": experimentID,
            "deviceID": metadata.deviceID,
            "location": metadata.location,
            "experimenter": metadata.experimenter
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadataDetails.compactMapValues { $0 })
            var request = URLRequest(url: serverURL.appendingPathComponent("metadata"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully synced metadata for \(experiment.name ?? "")")
            } else {
                print("Failed to sync metadata for \(experiment.name ?? ""): \(response)")
            }
        } catch {
            print("Error syncing metadata for \(experiment.name ?? ""): \(error)")
        }
    }
} 
