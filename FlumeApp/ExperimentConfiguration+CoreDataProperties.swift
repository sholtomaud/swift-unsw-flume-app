//
//  ExperimentConfiguration+CoreDataProperties.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//
//

import Foundation
import CoreData


extension ExperimentConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExperimentConfiguration> {
        return NSFetchRequest<ExperimentConfiguration>(entityName: "ExperimentConfiguration")
    }

    @NSManaged public var ultrasonicSensor1Enabled: Bool
    @NSManaged public var ultrasonicSensor2Enabled: Bool
    @NSManaged public var ultrasonicSensor3Enabled: Bool
    @NSManaged public var ultrasonicSensor4Enabled: Bool
    @NSManaged public var magneticSwitchEnabled: Bool
    @NSManaged public var experimentDuration: Double
    @NSManaged public var dataAcquisitionRate: Double
    @NSManaged public var experiment: Experiment?

}

extension ExperimentConfiguration : Identifiable {

}
