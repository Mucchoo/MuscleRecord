//
//  SettingView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var purchaseViewModel = PurchaseViewModel()
    @ObservedObject var firebaseViewModel = FirebaseViewModel()
    @ObservedObject var viewModel = ViewModel()
    @Binding var rootIsActive : Bool
    @State private var isActive = false
    @State private var isShowingAlert = false
    @State var isShowingReauthenticate = false
    @State var isShowingTutorial = false
    @State var isShowingMail = false
    @State private var mailData = Email(subject: R.string.localizable.messageSubject(), recipients: [R.string.localizable.messageResipients()], message: R.string.localizable.messageBody())
    
    var body: some View {
        SimpleNavigationView(title: R.string.localizable.settingViewTitle()) {
            VStack{
                Form{
                    //Proセクション
                    Section(header: Text(R.string.localizable.pro())){
                        //内課金購入済みの場合
                        if purchaseViewModel.isPurchased() {
                            FormRowView(icon: R.string.localizable.giftIcon(), firstText: R.string.localizable.unlockedPro(), isHidden: false)
                            NavigationLink(destination: ThemeColorView()) {FormRowView(icon: R.string.localizable.brushIcon(), firstText: R.string.localizable.themeColorViewTitle(), isHidden: false)}
                            NavigationLink(destination: IconView()) {
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(viewModel.getThemeColor())
                                            .frame(width: 36, height: 36)
                                        Image(R.string.localizable.logo())
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    Text(R.string.localizable.iconViewTitle()).foregroundColor(Color(R.color.fontColor()!))
                                    Spacer()
                                }
                            }
                        //内課金未購入の場合
                        } else {
                            NavigationLink(destination: ProView(shouldPopToRootView: $rootIsActive)) {
                                FormRowView(icon: R.string.localizable.giftIcon(), firstText: R.string.localizable.proViewTitle(), isHidden: false)
                            }
                            FormRowView(icon: R.string.localizable.brushIcon(), firstText: R.string.localizable.themeColorViewTitle(), isHidden: true)
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(viewModel.getThemeColor())
                                        .frame(width: 36, height: 36)
                                    Image(R.string.localizable.logo())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Text(R.string.localizable.iconViewTitle()).foregroundColor(Color(R.color.fontColor()!))
                                Spacer()
                            }.opacity(0.5)
                        }
                    }
                    Section(header: Text(R.string.localizable.application()), footer: Text(R.string.localizable.copyRight())){
                        //使い方
                        Button {
                            isShowingTutorial = true
                        } label: {
                            FormRowView(icon: R.string.localizable.questionIcon(), firstText: R.string.localizable.usage(), isHidden: false)
                        }
                        .fullScreenCover(isPresented: $isShowingTutorial) {
                            TutorialView(isShowingTutorial: $isShowingTutorial)
                        }
                        //シェア
                        Button {
                            viewModel.shareApp()
                        } label: {
                            FormRowView(icon: R.string.localizable.shareIcon(), firstText: R.string.localizable.shareApp(), isHidden: false)
                        }
                        //お問い合わせ
                        Button {
                            isShowingMail = true
                        } label: {
                            FormRowView(icon: R.string.localizable.envelopeIcon(), firstText: R.string.localizable.messageSubject(), isHidden: false)
                        }
                        .sheet(isPresented: $isShowingMail) {
                            MailView(data: $mailData) { result in }
                        }
                        //アカウント情報変更
                        Button {
                            isShowingReauthenticate = true
                        } label: {
                            FormRowView(icon: R.string.localizable.personIcon(), firstText: R.string.localizable.changeInfoViewTitle(), isHidden: false)
                        }
                        .sheet(isPresented: $isShowingReauthenticate) {
                            ReauthenticateView()
                        }
                        //ログアウト
                        Button(action: {
                            isShowingAlert = true
                        }) {
                            FormRowView(icon: R.string.localizable.logoutIcon(), firstText: R.string.localizable.logout(), isHidden: false)
                        }
                        .alert(isPresented: $isShowingAlert) {
                            return Alert(title: Text(R.string.localizable.logoutConfirm()), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text(R.string.localizable.logout()), action: {
                                firebaseViewModel.signOut()
                                dismiss()
                            }))
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .background(Color(R.color.backgroundColor()!).edgesIgnoringSafeArea(.all))
        }
    }
}
