//
//  PredictionResponse.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

struct PredictionResponse: Hashable, Codable {
    var success: Int
    var length_of_cycle: Int?
    var length_of_menses: Int?
    var unusual_bleeding: Int?
}
