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
    @State private var isShowingSignUp = false
    @Binding var isShowingTutorial: Bool
    
    var body: some View {
            ZStack(){
                //背景
                viewModel.getThemeColor().edgesIgnoringSafeArea(.all)
                VStack {
                    //タイトル
                    Text("使い方")
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
                            TutorialImageView(image: "Tutorial1")
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: "Tutorial3")
                            TutorialTextView(text: "まずは右上の ＋ ボタンから種目を追加しましょう")
                        }
                        //2枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial3")
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel.getThemeColor())
                            TutorialImageView(image: "Tutorial4")
                            Text("トレーニング後は\(Image(systemName: "pencil.circle.fill"))を押して記録できます")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                                .foregroundColor(.black)
                        }
                        //3枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial5")
                            TutorialTextView(text: "記録をすると結果がグラフに表れます")
                        }
                        //4枚目
                        TutorialCardView {
                            TutorialImageView(image: "Tutorial6")
                            TutorialTextView(text: "記録を続けて成長をデータ化しましょう！")
                            //始めるボタン
                            Button {
                                //未ログインの場合はアカウント作成ページ
                                if Auth.auth().currentUser == nil {
                                    isShowingSignUp = true
                                //ログイン済みの場合はトップページ
                                } else {
                                    isShowingTutorial = false
                                }
                            } label: {
                                ButtonView(text: "始める").padding(.vertical, 30)
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
