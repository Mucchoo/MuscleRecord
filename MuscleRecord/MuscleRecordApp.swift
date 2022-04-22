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
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil {
                NavigationView {
                    MuscleRecordView()
                }
            } else {
                TutorialView()
            }
        }
    }

}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // この間に AppDelegate.swift の処理を書く。今回は書いてない

        return true
    }
}
