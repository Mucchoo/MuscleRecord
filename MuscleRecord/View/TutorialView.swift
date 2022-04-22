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
    @State var showSignUp = false
    @State var showMuscleRecord = false

    init(){
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(viewModel.getThemeColor())
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(viewModel.getThemeColor())
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    var body: some View {
        NavigationView {
            ZStack(){
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                VStack {
//                    Text("\(Image(systemName: "questionmark.circle.fill")) 使い方")
//                        .font(.headline)
//                        .foregroundColor(viewModel.getThemeColor())
//                        .frame(width: 150, height: 30)
//                        .background(.white)
//                        .cornerRadius(25)
//                        .padding(10)
                    TabView{
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
                            Button {
                                showSignUp = true
                            } label: {
                                ButtonView(text: "始める").padding(.top, 30)
                            }
                        }
                        .background(viewModel.clearColor)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .sheet(isPresented: $showSignUp) {
                            SignUpView(showSignUp: $showSignUp, showMuscleRecord: $showMuscleRecord)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.all)
                    .padding(.vertical, 20)
                    NavigationLink(destination: MuscleRecordView(), isActive: $showMuscleRecord, label: {
                        EmptyView()
                    })
                }
            }
            .navigationBarTitle("使い方", displayMode: .inline)
        }
    }
}
