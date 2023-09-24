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
    @State private var isShowingResetPassword = false
    @State private var isShowingAlert = false
    @State private var password = ""
    @State private var email = ""
    @State private var error = ""
    
    enum Focus {
        case email, password
    }
    
    var body: some View {
        ZStack{
            //背景タップでキーボードを閉じる
            Color("ClearColor")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text("ログイン")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(Color("FontColor"))
                //フォーム
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                //ログインボタン
                Button( action: {
                    if email.isEmpty {
                        error = "メールアドレスが入力されていません"
                        isShowingAlert = true
                    } else if password.isEmpty {
                        error = "パスワードが入力されていません"
                        isShowingAlert = true
                    } else {
                        firebaseViewModel.signIn(email: email, password: password) { errorString in
                            error = errorString ?? ""
                            isShowingAlert = true
                        }
                    }
                }){
                    ButtonView(text: "ログイン").padding(.top, 20)
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
                .alert(isPresented: $isShowingAlert) {
                    
                    if error.isEmpty {
                        return Alert(title: Text("ログインに成功しました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    } else {
                        return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text("OK")))
                    }
                }
                Spacer()
            }.padding(20)
        }.sheet(isPresented: $isShowingResetPassword) {
            ResetPasswordView()
        }
    }
}
