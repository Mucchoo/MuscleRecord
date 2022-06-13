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
            ZStack(){
                //背景
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                VStack {
                    //タイトル
                    Text(R.string.localizable.usage())
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 200, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                    //ページビュー
                    TabView{
                        //1枚目
                        TutorialCardView {
                            TutorialImageView(image: R.string.localizable.tutorial1())
                            Image(systemName: R.string.localizable.arrowIcon())
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: R.string.localizable.tutorial2())
                            TutorialTextView(text: R.string.localizable.tutorialTextOne())
                        }
                        //2枚目
                        TutorialCardView {
                            TutorialImageView(image: R.string.localizable.tutorial2())
                            Image(systemName: R.string.localizable.arrowIcon())
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: R.string.localizable.tutorial3())
                            (Text(R.string.localizable.tutorialTextTwoFirst())
                            + Text((Image(systemName: R.string.localizable.pencilIconFill())))
                            + Text(R.string.localizable.tutorialTextTwoLast()))
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                                .foregroundColor(.black)
                        }
                        //3枚目
                        TutorialCardView {
                            TutorialImageView(image: R.string.localizable.tutorial4())
                            TutorialTextView(text: R.string.localizable.tutorialTextThree())
                        }
                        //4枚目
                        TutorialCardView {
                            TutorialImageView(image: R.string.localizable.tutorial5())
                            TutorialTextView(text: R.string.localizable.tutorialTextFour())
                            //始めるボタン
                            Button {
                                if firebaseViewModel.isLoggedIn() {
                                    isShowingTutorial = false
                                } else {
                                    isShowingSignUp = true
                                }
                            } label: {
                                ButtonView(text: R.string.localizable.start()).padding(.vertical, 30)
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
            .sheet(isPresented: $isShowingSignUp) {
                SignUpView()
            }
    }
}
