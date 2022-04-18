//
//  TutorialView2.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        ZStack(){
            viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
            TabView(){
                VStack(){
                    Spacer()
                    TutorialImageView(image: "Tutorial1")
                    TutorialArrowView()
                    TutorialImageView(image: "Tutorial3")
                    TutorialTextView(text: "まずは右上の「＋」ボタンから種目を追加！")
                    Spacer()
                }
                .background(viewModel.clearColor)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                VStack(){
                    Spacer()
                    TutorialImageView(image: "Tutorial3")
                    TutorialArrowView()
                    TutorialImageView(image: "Tutorial4")
                    Text("トレーニング後は\(Image(systemName: "pencil.circle.fill"))を押して記録！")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(viewModel.fontColor)
                    Spacer()
                }
                .background(viewModel.clearColor)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                VStack(){
                    Spacer()
                    TutorialImageView(image: "Tutorial5")
                    TutorialTextView(text: "記録をすると結果がグラフに表れます！")
                    Spacer()
                }
                .background(viewModel.clearColor)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                VStack(){
                    Spacer()
                    TutorialImageView(image: "Tutorial6")
                    TutorialTextView(text: "記録を続けて成長をデータ化しましょう！")
                    Button( action: {
                        dismiss()
                    }, label: {
                        ButtonView(text: "始める").padding(.top, 30)
                    })
                    Spacer()
                }
                .background(viewModel.clearColor)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            }
            .tabViewStyle(PageTabViewStyle())
            .edgesIgnoringSafeArea(.all)
            .padding(.vertical, 20)
        }
        .navigationTitle("使い方")
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
