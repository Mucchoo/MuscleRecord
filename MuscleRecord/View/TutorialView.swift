//
//  TutorialView2.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct TutorialView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var isShowingSignUp = false
    @Binding var isShowingTutorial: Bool
    
    var body: some View {
            ZStack {
                //背景
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                VStack {
                    //タイトル
                    Text("usage")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 200, height: 40)
                        .background(Color("ClearColor"))
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                    //ページビュー
                    TabView{
                        //1枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial1")
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: "Tutorial2")
                                .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                            TutorialTextView(text: String(localized: "tutorialTextOne"))
                        }
                        //2枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial2")
                                .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: "Tutorial3")
                                .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                            (Text("tutorialTextTwoFirst")
                            + Text((Image(systemName: "pencil.circle.fill")))
                            + Text("tutorialTextTwoLast"))
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                                .foregroundColor(Color("FontColor"))
                        }
                        //3枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial4")
                            TutorialTextView(text: String(localized: "tutorialTextThree"))
                        }
                        //4枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial5")
                            TutorialTextView(text: String(localized: "tutorialTextFour"))
                            //始めるボタン
                            Button {
                                if firebaseViewModel.isLoggedIn {
                                    isShowingTutorial = false
                                } else {
                                    isShowingSignUp = true
                                }
                            } label: {
                                ButtonView("start").padding(.vertical, 30)
                            }
                        }
                        .background(Color("ClearColor"))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.all)
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $isShowingSignUp) {
                SignUpView()
            }
    }
}
