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
            Color("ClearColor")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text("createAccount")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(Color("FontColor"))
                //フォーム
                TextFieldView(title: "emailAddress", text: $email, placeHolder: "emailAddressPlaceholder", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "password", text: $password, placeHolder: "passwordPlaceholder", isSecure: true)
                    .focused($focus, equals: .password)
                TextFieldView(title: "passwordConfirm", text: $confirm, placeHolder: "passwordPlaceholder", isSecure: true)
                    .focused($focus, equals: .confirm)
                //アカウント作成ボタン
                Button( action: {
                    error = ""
                    if email.isEmpty {
                        error = String(localized: "emailIsEmpty")
                        isShowingAlert = true
                    } else if password.isEmpty {
                        error = String(localized: "passwordIsEmpty")
                        isShowingAlert = true
                    } else if confirm.isEmpty {
                        error = String(localized: "passwordConfirmIsEmpty")
                        isShowingAlert = true
                    } else if password.compare(confirm) != .orderedSame {
                        error = String(localized: "passwordAndPasswordConfirmIsNotEqual")
                        isShowingAlert = true
                    } else {
                        firebaseViewModel.signUp(email: email, password: password) { errorMessage in
                            if let errorMessage {
                                error = errorMessage
                            }
                            
                            isShowingAlert = true
                        }
                    }
                }){
                    ButtonView("createAccount").padding(.top, 20)
                }
                //ログインボタン
                Button {
                    showSignIn = true
                } label: {
                    Text("loginExistingAccount")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                .alert(isPresented: $isShowingAlert) {
                    if error.isEmpty {
                        return Alert(title: Text("accountCreated"), message: Text(""), dismissButton: .default(Text("ok"), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    } else {
                        return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text("ok")))
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
