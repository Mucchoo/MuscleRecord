//
//  TutorialView2.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct TutorialView: View {
    @ObservedObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        SimpleNavigationView(title: "使い方") {
            ZStack(){
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                TabView(){
                    TutorialCardView {
                        TutorialImageView(image: "Tutorial1")
                        TutorialArrowView()
                        TutorialImageView(image: "Tutorial3")
                        TutorialTextView(text: "まずは右上の ＋ ボタンから種目を追加！")
                    }
                    TutorialCardView {
                        TutorialImageView(image: "Tutorial3")
                        TutorialArrowView()
                        TutorialImageView(image: "Tutorial4")
                        Text("トレーニング後は\(Image(systemName: "pencil.circle.fill"))を押して記録！")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .foregroundColor(viewModel.fontColor)
                    }
                    TutorialCardView {
                        TutorialImageView(image: "Tutorial5")
                        TutorialTextView(text: "記録をすると結果がグラフに表れます！")
                    }
                    TutorialCardView {
                        TutorialImageView(image: "Tutorial6")
                        TutorialTextView(text: "記録を続けて成長をデータ化しましょう！")
                        Button( action: {
                            dismiss()
                        }, label: {
                            ButtonView(text: "始める").padding(.top, 30)
                        })
                    }
                    .background(viewModel.clearColor)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                }
                .tabViewStyle(PageTabViewStyle())
                .edgesIgnoringSafeArea(.all)
                .padding(.vertical, 20)
            }
        }
    }
}
