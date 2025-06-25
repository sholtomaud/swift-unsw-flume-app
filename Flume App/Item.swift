//
//  Item.swift
//  Flume App
//
//  Created by Sholto Maud on 25/6/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
