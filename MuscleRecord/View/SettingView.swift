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
    @State private var isShowSignedOut = false
    @State var showTutorial = false

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
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        } label: {
                            FormRowView(icon: "star", firstText: "レビューで応援！")
                        }
                        FormRowView(icon: "square.and.arrow.up", firstText: "アプリをシェア")
                        FormRowView(icon: "envelope", firstText: "ご意見・ご要望")
                        Button(action: {
                            signOut()
                        }) {
                            FormRowView(icon: "rectangle.portrait.and.arrow.right", firstText: "ログアウト")
                        }
                        .alert(isPresented: $isShowSignedOut) {
                            Alert(title: Text(""), message: Text("ログアウトしました"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $showTutorial) {
                TutorialView(showTutorial: $showTutorial)
            }
            
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isShowSignedOut = true
        } catch let signOutError as NSError {
            print("サインアウトエラー: %@", signOutError)
        }
    }
}
