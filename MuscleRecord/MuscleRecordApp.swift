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
    }
    
    var body: some Scene {
        WindowGroup {
            MuscleRecordView()
        }
    }

}
