//
//  user.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import Foundation
//種目
struct Event: Identifiable {
    var id: String
    var name: String
    var latestWeight: Float
    var latestRep: Int
    var latestDate: Date
}
