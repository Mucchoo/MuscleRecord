//
//  IconView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct IconView: View {
    @Environment(\.dismiss) var dismiss
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        SimpleNavigationView(title: "アイコン") {
            GeometryReader{ geometry in
                ScrollView(){
                    LazyVGrid(columns: columns, spacing: 10) {
                        Button(action: {
                            UIApplication.shared.setAlternateIconName(nil)
                            dismiss()
                        }) {
                            Image("Icon")
                                .resizable()
                                .cornerRadius(20)
                        }.frame(width: (geometry.size.width - 40)/3, height: (geometry.size.width - 40)/3)
                        ForEach(0..<19) { num in
                            Button(action: {
                                UIApplication.shared.setAlternateIconName("AppIcon\(num)")
                                dismiss()
                            }) {
                                Image("Icon\(num)")
                                    .resizable()
                                    .cornerRadius(20)
                            }.frame(width: (geometry.size.width - 40)/3, height: (geometry.size.width - 40)/3)
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
}
