//
//  Period.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import Foundation
import SwiftData
import HorizonCalendar

@Model
final class Period {
    var startDate: Date
    var endDate: Date
    var intensity: Int
    init(startDate: Date, endDate: Date, intensity: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.intensity = intensity
    }
}
