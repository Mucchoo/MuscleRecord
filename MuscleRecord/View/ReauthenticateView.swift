//
//  ReauthenticateView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/24.
//

import SwiftUI
import Firebase

struct ReauthenticateView: View {
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
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
                    //不備やエラーを確認
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = "メールアドレスが入力されていません"
                        isShowingAlert = true
                    } else if password.isEmpty {
                        errorMessage = "パスワードが入力されていません"
                        isShowingAlert = true
                    } else {
                        signIn()
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
                    return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK")))
                }
                Spacer()
            }.padding(20)
        }
    }
    //サインイン
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                isShowingChangeInfo = true
            } else {
                isShowingAlert = true
                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = "メールアドレスの形式が正しくありません"
                    case .userNotFound, .wrongPassword:
                        errorMessage = "メールアドレス、またはパスワードが間違っています"
                    case .userDisabled:
                        errorMessage = "このユーザーアカウントは無効化されています"
                    default:
                        errorMessage = error.domain
                    }
                    isShowingAlert = true
                }
            }
        }
    }
}
