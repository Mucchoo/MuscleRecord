//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var password = ""
    @State private var email = ""
    @State private var error = ""
    @State private var isShowingResetPassword = false
    @State private var isShowingAlert = false
    
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
                    .padding(.bottom, 20)
                    .foregroundColor(Color(R.color.fontColor()!))
                //フォーム
                TextFieldView(title: R.string.localizable.emailAddress(), text: $email, placeHolder: R.string.localizable.emailAddressPlaceholder(), isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: R.string.localizable.password(), text: $password, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                    .focused($focus, equals: .password)
                //ログインボタン
                Button( action: {
                    if email.isEmpty {
                        error = R.string.localizable.emailIsEmpty()
                    } else if password.isEmpty {
                        error = R.string.localizable.passwordIsEmpty()
                    } else {
                        error = firebaseViewModel.signIn(email: email, password: password) ?? ""
                    }
                    isShowingAlert = true
                }){
                    ButtonView(text: R.string.localizable.login()).padding(.top, 20)
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
                .alert(isPresented: $isShowingAlert) {
                    if error.isEmpty {
                        return Alert(title: Text(R.string.localizable.loginSucceeded()), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok()), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    } else {
                        return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text(R.string.localizable.ok())))
                    }
                }
                Spacer()
            }.padding(20)
        }.sheet(isPresented: $isShowingResetPassword) {
            ResetPasswordView()
        }
    }
}
