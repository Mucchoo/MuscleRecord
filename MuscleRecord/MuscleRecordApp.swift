//
//  MuscleRecordApp.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/24.
//

import SwiftUI
import Firebase

@main
struct MuscleRecordApp: App {
    
    init() {
        //Firebase有効化
        FirebaseApp.configure()
        //アプリ起動回数を記録
        let launchedTimes = UserDefaults.standard.object(forKey: R.string.localizable.launchedTimes()) as? Int ?? 0
        UserDefaults.standard.set(launchedTimes + 1, forKey: R.string.localizable.launchedTimes())
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
