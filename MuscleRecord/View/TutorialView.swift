//
//  TutorialView2.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI
import Firebase

struct TutorialView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var showSignUp = false
    @Binding var showTutorial: Bool
    
    var body: some View {
            ZStack(){
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                VStack {
                    Text("\(Image(systemName: "questionmark.circle.fill")) 使い方")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 150, height: 30)
                        .background(.white)
                        .cornerRadius(25)
                        .padding(10)
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
                                .foregroundColor(.black)
                        }
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial5")
                            TutorialTextView(text: "記録をすると結果がグラフに表れます！")
                        }
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial6")
                            TutorialTextView(text: "記録を続けて成長をデータ化しましょう！")
                            Button {
                                if Auth.auth().currentUser == nil {
                                    showSignUp = true
                                } else {
                                    showTutorial = false
                                }
                            } label: {
                                ButtonView(text: "始める").padding(.top, 30)
                            }
                        }
                        .background(.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.all)
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
    }
}
