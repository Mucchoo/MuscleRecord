//
//  user.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import Foundation

struct Event: Identifiable {
    var id: String
    var latestWeight: Float
    var latestRep: Int
    var latestDate: Date
}
