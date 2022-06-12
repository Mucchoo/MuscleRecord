//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var error = ""
    @State private var email = ""
    @State private var confirm = ""
    @State private var password = ""
    @State private var isShowingAlert = false
    @State var showSignIn = false
    
    enum Focus {
        case email, password, confirm
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
                Text("アカウント作成")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                //フォーム
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                TextFieldView(title: "確認用パスワード", text: $confirm, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .confirm)
                //アカウント作成ボタン
                Button( action: {
                    error = ""
                    if email.isEmpty {
                        error = "メールアドレスが入力されていません"
                    } else if password.isEmpty {
                        error = "パスワードが入力されていません"
                    } else if confirm.isEmpty {
                        error = "確認用パスワードが入力されていません"
                    } else if password.compare(confirm) != .orderedSame {
                        error = "パスワードと確認パスワードが一致しません"
                    } else {
                        error = firebaseViewModel.signUp(email: email, password: password) ?? ""
                    }
                    isShowingAlert = true
                }){
                    ButtonView(text: "アカウント作成").padding(.top, 20)
                }
                //ログインボタン
                Button {
                    showSignIn = true
                } label: {
                    Text("既存のアカウントにログイン")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                .alert(isPresented: $isShowingAlert) {
                    if error.isEmpty {
                        return Alert(title: Text("アカウントが作成されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    } else {
                        return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text("OK")))
                    }
                }
                Spacer()
            }.padding(20)
        //ログインページ
        }.sheet(isPresented: $showSignIn) {
            SignInView()
        }
    }
}
