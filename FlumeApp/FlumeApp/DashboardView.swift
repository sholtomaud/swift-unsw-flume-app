
import SwiftUI

struct DashboardView: View {
    // Dashboard state variables (placeholders)
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
        }
    }
}

#Preview {
    DashboardView()
}
