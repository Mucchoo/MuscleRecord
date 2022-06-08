//
//  SettingView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import Firebase
import SwiftUI
import StoreKit

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @Binding var rootIsActive : Bool
    @State private var isActive = false
    @State private var isShowingAlert = false
    @State var isShowingReauthenticate = false
    @State var isShowingTutorial = false
    @State var isShowingMail = false
    @State private var mailData = Email(subject: "ご意見・ご要望", recipients: ["yazujumusa@gmail.com"], message: "\n\n\n\n\nーーーーーーーーーーーーーーーーー\nこの上へお気軽にご記入ください。\n筋トレ記録")
    
    var body: some View {
        SimpleNavigationView(title: "設定") {
            VStack{
                Form{
                    //Proセクション
                    Section(header: Text("Pro")){
                        //内課金状態で表示内容を切り替え
                        if viewModel.customerInfo() {
                            //選択できない項目
                            FormRowView(icon: "gift", firstText: "Proアンロック済み", isHidden: false)
                            //テーマカラー
                            NavigationLink(destination: ThemeColorView()) {FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー", isHidden: false)}
                            //アイコン
                            NavigationLink(destination: IconView()) {
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(viewModel.getThemeColor())
                                            .frame(width: 36, height: 36)
                                        Image("Logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    Text("アイコン").foregroundColor(Color("FontColor"))
                                    Spacer()
                                }
                            }
                        } else {
                            //Proをアンロック
                            NavigationLink(destination: ProView(shouldPopToRootView: $rootIsActive)) {
                                FormRowView(icon: "gift", firstText: "Proをアンロック", isHidden: false)
                            }
                            //選択できない項目
                            FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー", isHidden: true)
                            //選択できない項目
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(viewModel.getThemeColor())
                                        .frame(width: 36, height: 36)
                                    Image("Logo")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Text("アイコン").foregroundColor(Color("FontColor"))
                                Spacer()
                            }.opacity(0.5)
                        }
                    }
                    Section(header: Text("アプリケーション"), footer: Text("©︎ 2022 Musa Yazuju")){
                        //使い方
                        Button {
                            isShowingTutorial = true
                        } label: {
                            FormRowView(icon: "questionmark", firstText: "使い方", isHidden: false)
                        }
                        .fullScreenCover(isPresented: $isShowingTutorial) {
                            TutorialView(isShowingTutorial: $isShowingTutorial)
                        }
                        //レビュー
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        } label: {
                            FormRowView(icon: "star", firstText: "レビューで応援！", isHidden: false)
                        }
                        //シェア
                        Button {
                            viewModel.shareApp()
                        } label: {
                            FormRowView(icon: "square.and.arrow.up", firstText: "アプリをシェア", isHidden: false)
                        }
                        //お問い合わせ
                        Button {
                            isShowingMail = true
                        } label: {
                            FormRowView(icon: "envelope", firstText: "ご意見・ご要望", isHidden: false)
                        }
                        .sheet(isPresented: $isShowingMail) {
                            MailView(data: $mailData) { result in }
                        }
                        //アカウント情報変更
                        Button {
                            isShowingReauthenticate = true
                        } label: {
                            FormRowView(icon: "person", firstText: "アカウント情報変更", isHidden: false)
                        }
                        .sheet(isPresented: $isShowingReauthenticate) {
                            ReauthenticateView()
                        }
                        //ログアウト
                        Button(action: {
                            isShowingAlert = true
                        }) {
                            FormRowView(icon: "rectangle.portrait.and.arrow.right", firstText: "ログアウト", isHidden: false)
                        }
                        .alert(isPresented: $isShowingAlert) {
                            return Alert(title: Text("本当にログアウトしますか？"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("ログアウト"), action: {
                                signOut()
                            }))
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        }
    }
    //ログアウト
    private func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch let signOutError as NSError {
            print("サインアウトエラー\(signOutError)")
        }
    }
}
