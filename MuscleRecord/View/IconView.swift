//
//  IconView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct IconView: View {
    @Environment(\.dismiss) private var dismiss
    //縦3列にグリッドを表示
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        SimpleNavigationView(title: String(localized: "iconViewTitle")) {
            GeometryReader{ geometry in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        //初期アイコンに変更
                        Button(action: {
                            UIApplication.shared.setAlternateIconName(nil)
                            dismiss()
                        }) {
                            Image("Icon")
                                .resizable()
                                .cornerRadius(20)
                        }
                        .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                        .frame(width: (geometry.size.width - 40)/3, height: (geometry.size.width - 40)/3)
                        //初期以外のアイコンを変更
                        ForEach(0..<19) { num in
                            Button(action: {
                                UIApplication.shared.setAlternateIconName("AppIcon" + String(num))
                                dismiss()
                            }) {
                                Image("Icon" + String(num))
                                    .resizable()
                                    .cornerRadius(20)
                            }
                            .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                            .frame(width: (geometry.size.width - 40)/3, height: (geometry.size.width - 40)/3)
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
}
