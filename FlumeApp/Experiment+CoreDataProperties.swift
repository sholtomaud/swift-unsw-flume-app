//
//  Experiment+CoreDataProperties.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//
//

import Foundation
import CoreData


extension Experiment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Experiment> {
        return NSFetchRequest<Experiment>(entityName: "Experiment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var videoPath: String?
    @NSManaged public var status: String?
    @NSManaged public var notes: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var configuration: ExperimentConfiguration?
    @NSManaged public var sensorData: SensorDataPoint?
    @NSManaged public var metadata: ExperimentMetadata?

}

extension Experiment : Identifiable {

}
