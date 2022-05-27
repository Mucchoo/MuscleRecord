//
//  Record.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/05.
//

import Foundation
//記録
struct Record: Identifiable {
    var id: String
    var date: Date
    var weight: Float
    var rep: Int
    var dummy: Bool
}
