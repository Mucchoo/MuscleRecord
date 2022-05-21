//
//  MuscleRecordApp.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/24.
//

import SwiftUI
import Firebase
import RevenueCat

@main
struct MuscleRecordApp: App {
        
    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "appl_xBBDyDHmiVldcADDnLdXFbOGQRH")
        let launchedTimes = UserDefaults.standard.object(forKey: "LaunchedTimes") as? Int ?? 0
        UserDefaults.standard.set(launchedTimes + 1, forKey: "LaunchedTimes")
    }
    
    var body: some Scene {
        WindowGroup {
            MuscleRecordView()
        }
    }

}
