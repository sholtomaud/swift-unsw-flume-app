//
//  ExperimentMetadata+CoreDataProperties.swift
//  FlumeApp
//
//  Created by Sholto Maud on 28/6/2025.
//
//

import Foundation
import CoreData


extension ExperimentMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExperimentMetadata> {
        return NSFetchRequest<ExperimentMetadata>(entityName: "ExperimentMetadata")
    }

    @NSManaged public var location: String?
    @NSManaged public var experimenter: String?
    @NSManaged public var deviceID: String?
    @NSManaged public var metadata: Experiment?

}

extension ExperimentMetadata : Identifiable {

}
