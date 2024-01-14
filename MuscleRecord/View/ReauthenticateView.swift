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
            Color(R.color.clearColor()!)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text(R.string.localizable.login())
                    .font(.headline)
                    .padding(.bottom, 10)
                    .foregroundColor(Color(R.color.fontColor()!))
                //説明文
                Text(R.string.localizable.needLoginToChangeAccount())
                    .font(.body)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(R.color.fontColor()!))
                    .multilineTextAlignment(.center)
                //メールアドレスtextField
                TextFieldView(title: R.string.localizable.emailAddress(), text: $email, placeHolder: R.string.localizable.emailAddressPlaceholder(), isSecure: false)
                    .focused($focus, equals: .email)
                //パスワードtextField
                TextFieldView(title: R.string.localizable.password(), text: $password, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                    .focused($focus, equals: .password)
                //ログインボタン
                Button( action: {
                    error = ""
                    if email.isEmpty {
                        error = R.string.localizable.emailIsEmpty()
                    } else if password.isEmpty {
                        error = R.string.localizable.passwordIsEmpty()
                    } else {
                        error = firebaseViewModel.signIn(email: email, password: password) ?? ""
                    }
                    if error.isEmpty {
                        isShowingChangeInfo = true
                    } else {
                        isShowingAlert = true
                    }
                }){
                    ButtonView(text: R.string.localizable.login()).padding(.top, 20)
                }
                //アカウント情報変更ページ
                .sheet(isPresented: $isShowingChangeInfo) {
                    ChangeInfoView()
                }
                //パスワードを忘れたボタン
                Button {
                    isShowingResetPassword = true
                } label: {
                    Text(R.string.localizable.forgotPassword())
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
                    return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text(R.string.localizable.ok())))
                }
                Spacer()
            }.padding(20)
        }
    }
}
