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
        ScrollView(){
            VStack(spacing: 10){
                ProTitleView(icon: "list.bullet", title: "種目数")
                HStack(){
                    ProTextView(text: "種目数：5個　→")
                    Image(systemName: "infinity.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.getThemeColor())
                    ProTextView(text: "無制限")
                }
                ProTitleView(icon: "Logo", title: "アイコン").padding(.top, 20)
                ProImageView(image: "Icons")
                ProTextView(text: "アイコン：1個　→ 20個")
                ProTitleView(icon: "paintbrush.pointed.fill", title: "テーマカラー").padding(.top, 20)
                ProImageView(image: "Themes")
                ProTextView(text: "テーマカラー：1色　→ 6色")
                Text("Proプラン - 300円/月")
                    .font(.headline)
                    .padding(.top, 20)
                Button( action: {
                    dismiss()
                }, label: {
                    ButtonView(text: "購入する")
                })
            }.padding(20)
        }
        .navigationTitle("Proにアップグレード")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                    }
                ).tint(.white)
            }
        }
    }
}
