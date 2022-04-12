//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/11.
//

import SwiftUI

struct ViewModel {
    var fontColor = Color("FontColor")
    var cellColor = Color("CellColor")
    var BackgroundColor = Color("BackgroundColor")
    
    var themeColor: Color {
        switch UserDefaults.standard.integer(forKey: "themeColorNumber") {
        case 0:
            return Color("ThemeColor0")
        case 1:
            return Color("ThemeColor1")
        case 2:
            return Color("ThemeColor2")
        case 3:
            return Color("ThemeColor3")
        case 4:
            return Color("ThemeColor4")
        case 5:
            return Color("ThemeColor5")
        default:
            return Color("ThemeColor0")
        }
    } 
}
