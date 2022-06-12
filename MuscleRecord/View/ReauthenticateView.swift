//
//  ReauthenticateView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/24.
//

import SwiftUI

struct ReauthenticateView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var error = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingAlert = false
    @State private var isShowingChangeInfo = false
    @State private var isShowingResetPassword = false
    
    enum Focus {
        case email, password
    }
    
    var body: some View {
        ZStack{
            //背景タップでキーボードを閉じる
            viewModel.clearColor
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text("ログイン")
                    .font(.headline)
                    .padding(.bottom, 10)
                    .foregroundColor(viewModel.fontColor)
                //説明文
                Text("アカウント情報を変更するには一度ログインする必要があります。")
                    .font(.body)
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                    .multilineTextAlignment(.center)
                //メールアドレスtextField
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                //パスワードtextField
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                //ログインボタン
                Button( action: {
                    error = ""
                    if email.isEmpty {
                        error = "メールアドレスが入力されていません"
                    } else if password.isEmpty {
                        error = "パスワードが入力されていません"
                    } else {
                        error = firebaseViewModel.signIn(email: email, password: password) ?? ""
                    }
                    if error.isEmpty {
                        isShowingChangeInfo = true
                    } else {
                        isShowingAlert = true
                    }
                }){
                    ButtonView(text: "ログイン").padding(.top, 20)
                }
                //アカウント情報変更ページ
                .sheet(isPresented: $isShowingChangeInfo) {
                    ChangeInfoView()
                }
                //パスワードを忘れたボタン
                Button {
                    isShowingResetPassword = true
                } label: {
                    Text("パスワードを忘れた")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                //パスワード変更ページ
                .sheet(isPresented: $isShowingResetPassword) {
                    ResetPasswordView()
                }
                //エラーアラート
                .alert(isPresented: $isShowingAlert) {
                    return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text("OK")))
                }
                Spacer()
            }.padding(20)
        }
    }
}
