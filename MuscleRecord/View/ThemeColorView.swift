//
//  ThemeColorView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/10.
//

import SwiftUI

struct ThemeColorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @State var isColorChanged = false
    var body: some View {
        if isColorChanged {
            //色が変更されたらトップページに切り替える
            HomeView()
            //既存のナビゲーションバーを削除
            .navigationBarHidden(true)
        } else {
            SimpleNavigationView(title: "テーマカラー") {
                VStack(spacing: 0){
                    //色選択ボタン
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(0..<3) { i in
                                Button(action: {
                                    UserDefaults.standard.set(i, forKey: "themeColorNumber")
                                    isColorChanged = true
                                }) {
                                    Rectangle()
                                        .foregroundColor(Color("ThemeColor\(i)"))
                                }
                            }
                        }
                        HStack(spacing: 0) {
                            ForEach(3..<6) { i in
                                Button(action: {
                                    UserDefaults.standard.set(i, forKey: "themeColorNumber")
                                    isColorChanged = true
                                }) {
                                    Rectangle()
                                        .foregroundColor(Color("ThemeColor\(i)"))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
