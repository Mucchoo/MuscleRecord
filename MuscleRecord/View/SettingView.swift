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
    @State private var isActive = false
    @State var showTutorial = false
    @State var showMail = false
    @State var showAlert = false
    @State var showReauthenticate = false
    @State private var mailData = Email(subject: "ご意見・ご要望", recipients: ["yazujumusa@gmail.com"], message: "\n\n\n\n\nーーーーーーーーーーーーーーーーー\nこの上へお気軽にご記入ください。\nMuscle Record")
    
    var body: some View {
        SimpleNavigationView(title: "設定") {
            VStack{
                Form{
                    Section(header: Text("Pro")){
                        NavigationLink(destination: ProView()) {FormRowView(icon: "gift", firstText: "Proにアップグレード")}
                        NavigationLink(destination: ThemeColorView()) {FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー")}
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
                    }
                    Section(footer: Text("©︎ 2022 Musa Yazuju")){
                        Button {
                            showTutorial = true
                        } label: {
                            FormRowView(icon: "questionmark", firstText: "使い方")
                        }
                        .fullScreenCover(isPresented: $showTutorial) {
                            TutorialView(showTutorial: $showTutorial)
                        }
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        } label: {
                            FormRowView(icon: "star", firstText: "レビューで応援！")
                        }
                        Button {
                            viewModel.shareApp()
                        } label: {
                            FormRowView(icon: "square.and.arrow.up", firstText: "アプリをシェア")
                        }
                        Button {
                            showMail = true
                        } label: {
                            FormRowView(icon: "envelope", firstText: "ご意見・ご要望")
                        }
                        .disabled(!MailView.canSendMail)
                        .sheet(isPresented: $showMail) {
                            MailView(data: $mailData) { result in
                                print(result)
                            }
                        }
                        Button {
                            showReauthenticate = true
                        } label: {
                            FormRowView(icon: "person", firstText: "アカウント情報変更")
                        }
                        .sheet(isPresented: $showReauthenticate) {
                            ReauthenticateView()
                        }
                        Button(action: {
                            showAlert = true
                        }) {
                            FormRowView(icon: "rectangle.portrait.and.arrow.right", firstText: "ログアウト")
                        }
                        .alert(isPresented: $showAlert) {
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
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch let signOutError as NSError {
            print("サインアウトエラー: %@", signOutError)
        }
    }
}
