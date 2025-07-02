//
//  SensorDataPoint+CoreDataProperties.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//
//

import Foundation
import CoreData


extension SensorDataPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorDataPoint> {
        return NSFetchRequest<SensorDataPoint>(entityName: "SensorDataPoint")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var ultrasonic1: Double
    @NSManaged public var ultrasonic2: Double
    @NSManaged public var ultrasonic3: Double
    @NSManaged public var ultrasonic4: Double
    @NSManaged public var magneticSwitch: Bool
    @NSManaged public var sensorData: Experiment?

}

extension SensorDataPoint : Identifiable {

}
