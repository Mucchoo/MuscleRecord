//
//  ProView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct ProView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        SimpleNavigationView(title: "Proにアップグレード") {
            ScrollView(){
                VStack(spacing: 10){
                    ProTitleView(icon: "Logo", title: "アイコン解放", isImage: true)
                    Image("Icons")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    ProTitleView(icon: "hammer.circle.fill", title: "テーマカラー解放", isImage: false)
                    Image("Themes")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    ProTitleView(icon: "lock.circle.fill", title: "種目数：5個 → 無制限", isImage: false)
                    Text("Proプラン - 120円/月")
                        .font(.headline)
                        .padding(.top, 20)
                    Button( action: {
                        dismiss()
                    }, label: {
                        ButtonView(text: "購入する")
                    })
                }.padding(20)
            }
        }
    }
}
