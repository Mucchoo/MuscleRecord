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
                ZStack(){
                    RoundedRectangle(cornerRadius: 100).foregroundColor(viewModel.getThemeColor())
                    HStack(){
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(.white)
                        Text("種目数")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }.padding(5)
                }
                HStack(){
                    Text("種目数：5個　→")
                        .font(.headline)
                        .foregroundColor(viewModel.fontColor)
                    Image(systemName: "infinity.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.getThemeColor())
                    Text("無制限")
                        .font(.headline)
                        .foregroundColor(viewModel.fontColor)
                }
                ZStack(){
                    RoundedRectangle(cornerRadius: 100).foregroundColor(viewModel.getThemeColor())
                    HStack(){
                        Image("Logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Text("アイコン")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }.padding(5)
                }.padding(.top, 20)
                Image("Icons")
                    .resizable()
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.getThemeColor(), lineWidth: 3))
                Text("アイコン：1個　→ 20個")
                    .font(.headline)
                    .foregroundColor(viewModel.fontColor)
                ZStack(){
                    RoundedRectangle(cornerRadius: 100).foregroundColor(viewModel.getThemeColor())
                    HStack(){
                        Image(systemName: "paintbrush.pointed.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Text("テーマカラー")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }.padding(5)
                }.padding(.top, 20)
                Image("Themes")
                    .resizable()
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.getThemeColor(), lineWidth: 3))
                Text("テーマカラー：1色　→ 6色")
                    .font(.headline)
                    .foregroundColor(viewModel.fontColor)
                Text("Proプラン - 300円/月")
                    .font(.headline)
                    .padding(.top, 20)
                Button( action: {
                    dismiss()
                }, label: {
                    Text("購入する")
                        .fontWeight(.bold)
                        .frame(width: 300, height: 70, alignment: .center)
                        .background(viewModel.getThemeColor())
                        .foregroundColor(.white)
                        .cornerRadius(20)
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
