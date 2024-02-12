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
    @State private var isShowingAlert = false
    @State var isShowingReauthenticate = false
    @State var isShowingTutorial = false
    @State var isShowingMail = false
    @State private var mailData = Email(subject: String(localized: "messageSubject"), recipients: [String(localized: "messageResipients")], message: String(localized: "messageBody"))
    
    var body: some View {
        SimpleNavigationView(title: String(localized: "settingViewTitle")) {
            VStack{
                Form{
                    //Proセクション
                    Section(header: Text("pro")){
                        //内課金購入済みの場合
                        if UserDefaults.standard.bool(forKey: "purchaseStatus") {
                            FormRowView(icon: "gift", firstText: String(localized: "unlockedPro"), isHidden: false)
                            NavigationLink(destination: ThemeColorView()) {FormRowView(icon: "paintbrush.pointed.fill", firstText: String(localized: "themeColorViewTitle"), isHidden: false)}
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
                                    Text("iconViewTitle").foregroundColor(Color("FontColor"))
                                    Spacer()
                                }
                            }
                        //内課金未購入の場合
                        } else {
                            NavigationLink(destination: ProView()) {
                                FormRowView(icon: "gift", firstText: String(localized: "proViewTitle"), isHidden: false)
                            }
                            FormRowView(icon: "paintbrush.pointed.fill", firstText: String(localized: "themeColorViewTitle"), isHidden: true)
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(viewModel.getThemeColor())
                                        .frame(width: 36, height: 36)
                                    Image("Logo")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Text("iconViewTitle").foregroundColor(Color("FontColor"))
                                Spacer()
                            }.opacity(0.5)
                        }
                    }
                    Section(header: Text("application"), footer: Text("copyRight")){
                        //使い方
                        Button {
                            isShowingTutorial = true
                        } label: {
                            FormRowView(icon: "questionmark", firstText: String(localized: "usage"), isHidden: false)
                        }
                        .fullScreenCover(isPresented: $isShowingTutorial) {
                            TutorialView(isShowingTutorial: $isShowingTutorial)
                        }
                        //シェア
                        Button {
                            viewModel.shareApp()
                        } label: {
                            FormRowView(icon: "square.and.arrow.up", firstText: String(localized: "shareApp"), isHidden: false)
                        }
                        //お問い合わせ
                        Button {
                            isShowingMail = true
                        } label: {
                            FormRowView(icon: "envelope", firstText: String(localized: "messageSubject"), isHidden: false)
                        }
                        .sheet(isPresented: $isShowingMail) {
                            MailView(data: $mailData) { result in }
                        }
                        //アカウント情報変更
                        Button {
                            isShowingReauthenticate = true
                        } label: {
                            FormRowView(icon: "person", firstText: String(localized: "changeInfoViewTitle"), isHidden: false)
                        }
                        .sheet(isPresented: $isShowingReauthenticate) {
                            ReauthenticateView()
                        }
                        //ログアウト
                        Button(action: {
                            isShowingAlert = true
                        }) {
                            FormRowView(icon: "rectangle.portrait.and.arrow.right", firstText: String(localized: "logout"), isHidden: false)
                        }
                        .alert(isPresented: $isShowingAlert) {
                            return Alert(title: Text("logoutConfirm"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("logout"), action: {
                                firebaseViewModel.signOut()
                                dismiss()
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
}
