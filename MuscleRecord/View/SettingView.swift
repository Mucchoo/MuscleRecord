//
//  SettingView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var isActive = false
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingDeleteFailedAlert = false
    @State var isShowingReauthenticate = false
    @State var isShowingTutorial = false
    @State var isShowingMail = false
    @State private var passwordTextFieldValue = ""
    @State private var deleteFailedError = ""
    @State private var mailData = Email(subject: "ご意見・ご要望", recipients: ["yazujumusa@gmail.com"], message: "\n\n\n\n\nーーーーーーーーーーーーーーーーー\nこの上へお気軽にご記入ください。\n筋トレ記録")
    
    var body: some View {
        SimpleNavigationView(title: "設定") {
            VStack{
                Form{
                    //Proセクション
                    Section(header: Text("pro")){
                        //内課金購入済みの場合
                        if UserDefaults.standard.bool(forKey: "PurchaseStatus") {
                            FormRowView(icon: "gift", firstText: "Proアンロック済み", isHidden: false)
                            NavigationLink(destination: ThemeColorView()) {FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー", isHidden: false)}
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
                        //内課金未購入の場合
                        } else {
                            NavigationLink(destination: ProView()) {
                                FormRowView(icon: "gift", firstText: "Proをアンロック", isHidden: false)
                            }
                            FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー", isHidden: true)
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
                    Section(header: Text("アプリケーション"), footer: Text("©︎ 2023 Musa Yazici")){
                        //使い方
                        Button {
                            isShowingTutorial = true
                        } label: {
                            FormRowView(icon: "questionmark", firstText: "使い方", isHidden: false)
                        }
                        .fullScreenCover(isPresented: $isShowingTutorial) {
                            TutorialView(isShowingTutorial: $isShowingTutorial)
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
                            showingLogoutAlert = true
                        }) {
                            FormRowView(icon: "rectangle.portrait.and.arrow.right", firstText: "ログアウト", isHidden: false)
                        }
                        .alert(isPresented: $showingLogoutAlert) {
                            return Alert(title: Text("本当にログアウトしますか？"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("ログアウト"), action: {
                                firebaseViewModel.signOut()
                                dismiss()
                            }))
                        }
                        //アカウント削除
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            FormRowView(icon: "trash", firstText: "アカウント削除", isHidden: false)
                        }
                        .alert("アカウントを削除するには、ログイン時のパスワードを入力してください。", isPresented: $showingDeleteAlert) {
                            SecureField("password", text: $passwordTextFieldValue)
                            Button("キャンセル", role: .cancel) {}
                            Button("削除", role: .destructive) {
                                firebaseViewModel.deleteAccount(password: passwordTextFieldValue) { error in
                                    passwordTextFieldValue = ""
                                    
                                    if let error {
                                        showingDeleteFailedAlert = true
                                        deleteFailedError = error.localizedDescription
                                    }
                                }
                            }
                        }
                        .alert("アカウント削除に失敗しました", isPresented: $showingDeleteFailedAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(deleteFailedError)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        }
    }
}
