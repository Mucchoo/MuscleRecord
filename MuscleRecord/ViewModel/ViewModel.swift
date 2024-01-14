//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import SwiftUI
import StoreKit

class ViewModel: ObservableObject {
    //テーマカラーの取得
    func getThemeColor() -> Color {
        switch UserDefaults.standard.integer(forKey: R.string.localizable.themeColorNumber()) {
        case 1:
            return Color(R.color.themeColor1()!)
        case 2:
            return Color(R.color.themeColor2()!)
        case 3:
            return Color(R.color.themeColor3()!)
        case 4:
            return Color(R.color.themeColor4()!)
        case 5:
            return Color(R.color.themeColor5()!)
        default:
            return Color(R.color.themeColor0()!)
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
        let productURL:URL = URL(string: R.string.localizable.appURL())!
        let av = UIActivityViewController(activityItems: [productURL],applicationActivities: nil)
        Window.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    //20回起動毎にレビューアラート表示
    func showReviewForEvery20Launchs() {
        if UserDefaults.standard.integer(forKey: R.string.localizable.launchedTimes()) > 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                UserDefaults.standard.set(0, forKey: R.string.localizable.launchedTimes())
            }
        }
    }
}
