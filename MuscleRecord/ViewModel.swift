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
    @State var appearance: ColorScheme?
    
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
    
    mutating func getAppearance(){
        if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            appearance = .dark
        } else if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            appearance = nil
        } else {
            appearance = .light
        }
        print("getAppearance発動")
        print(UserDefaults.standard.integer(forKey: "appearance"))
    }
    
    var appearanceName: String {
        if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            return "Dark"
        } else if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            return "Auto"
        } else {
            return "Light"
        }
    }
}
