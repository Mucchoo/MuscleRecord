//
//  Window.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/05/31.
//

import SwiftUI

struct Window {
    //iOS15以降でも使えるwindow
    static var first: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
}
