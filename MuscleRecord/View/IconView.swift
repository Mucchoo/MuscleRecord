//
//  IconView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct IconView: View {
    @Environment(\.dismiss) var dismiss
    //縦3列にグリッドを表示
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        SimpleNavigationView(title: R.string.localizable.iconViewTitle()) {
            GeometryReader{ geometry in
                ScrollView(){
                    LazyVGrid(columns: columns, spacing: 10) {
                        //1つ目のアイテムだけ処理が違うので分けて表示
                        Button(action: {
                            //初期アイコンに変更
                            UIApplication.shared.setAlternateIconName(nil)
                            dismiss()
                        }) {
                            Image(R.string.localizable.icon())
                                .resizable()
                                .cornerRadius(20)
                        //余白10pxで3列に表示
                        }.frame(width: (geometry.size.width - 40)/3, height: (geometry.size.width - 40)/3)
                        //2つ目以降のアイテム
                        ForEach(0..<19) { num in
                            Button(action: {
                                //アイコンを変更
                                UIApplication.shared.setAlternateIconName(R.string.localizable.appIcon() + String(num))
                                dismiss()
                            }) {
                                Image(R.string.localizable.icon() + String(num))
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
