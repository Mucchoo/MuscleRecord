//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import Firebase
import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isShowingResetPassword = false
    @State private var isShowingAlert = false
    @State private var isError = false
    
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
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                //フォーム
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                //ログインボタン
                Button( action: {
                    if email.isEmpty {
                        isError = true
                        errorMessage = "メールアドレスが入力されていません"
                        isShowingAlert = true
                    } else if password.isEmpty {
                        isError = true
                        errorMessage = "パスワードが入力されていません"
                        isShowingAlert = true
                    } else {
                        signIn()
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
                    //エラーアラート
                    if isError {
                        return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK"))
                        )
                        //成功アラート
                    } else {
                        return Alert(title: Text("ログインに成功しました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
                Spacer()
            }.padding(20)
        }.sheet(isPresented: $isShowingResetPassword) {
            ResetPasswordView()
        }
    }
    //サインイン
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                isShowingAlert = true
            } else {
                isShowingAlert = true
                isError = true
                if let error = error as NSError? {
                    errorMessage = error.localizedDescription
                    isShowingAlert = true
                }
            }
        }
    }
}
