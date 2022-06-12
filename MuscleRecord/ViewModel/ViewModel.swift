//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import SwiftUI
import StoreKit

class ViewModel: ObservableObject {
    @Published var fontColor = Color("FontColor")
    @Published var cellColor = Color("CellColor")
    @Published var clearColor = Color("ClearColor")
    @Published var backgroundColor = Color("BackgroundColor")
    //テーマカラーの取得
    func getThemeColor() -> Color {
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
    //記録時のdateFormat
    func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    //シェア
    func shareApp(){
        let productURL:URL = URL(string: "https://apps.apple.com/us/app/%E7%AD%8B%E3%83%88%E3%83%AC%E8%A8%98%E9%8C%B2-%E7%AD%8B%E8%82%89%E3%81%AE%E6%88%90%E9%95%B7%E3%82%92%E3%83%87%E3%83%BC%E3%82%BF%E5%8C%96-%E3%83%88%E3%83%AC%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0%E8%A8%98%E9%8C%B2/id1622549301?itsct=apps_box_link&itscg=30200")!
        let av = UIActivityViewController(activityItems: [productURL],applicationActivities: nil)
        Window.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    //20回起動毎にレビューアラート表示
    func showReviewForEvery20Launchs() {
        if UserDefaults.standard.integer(forKey: "launchedTimes") > 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                UserDefaults.standard.set(0, forKey: "launchedTimes")
            }
        }
    }
}
