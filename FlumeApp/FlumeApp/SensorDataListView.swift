
import SwiftUI
import CoreData

struct SensorDataListView: View {
    let sensorData: NSSet
    let itemFormatter: DateFormatter

    var body: some View {
        ForEach(sortedSensorDataPoints(from: sensorData)) { dataPoint in
            VStack(alignment: .leading) {
                Text("Timestamp: \(dataPoint.timestamp ?? Date(), formatter: itemFormatter)")
                Text("Ultrasonic 1: \(ultrasonic1Text(for: dataPoint))")
                Text("Magnetic Switch: \(magneticSwitchStatus(for: dataPoint))")
            }
        }
    }

    private func sortedSensorDataPoints(from sensorData: NSSet) -> [SensorDataPoint] {
        sensorData.allObjects.compactMap { $0 as? SensorDataPoint }.sorted(by: { $0.timestamp ?? Date.distantPast < $1.timestamp ?? Date.distantPast })
    }

    private func ultrasonic1Text(for dataPoint: SensorDataPoint) -> String {
        String(format: "%.2f", dataPoint.ultrasonic1)
    }

    private func magneticSwitchStatus(for dataPoint: SensorDataPoint) -> String {
        dataPoint.magneticSwitch ? "On" : "Off"
    }
}
