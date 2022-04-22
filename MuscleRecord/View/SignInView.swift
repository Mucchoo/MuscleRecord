//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import Firebase
import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    
    @State private var isSignedIn = false
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    enum Focus {
        case email, password
    }
    
    var body: some View {
        SimpleNavigationView(title: "ログイン") {
            ZStack{
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = nil
                    }
                VStack(spacing: 0){
                    TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                        .focused($focus, equals: .email)
                    TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .password)
                    Button( action: {
                        errorMessage = ""
                        if email.isEmpty {
                            errorMessage = "メールアドレスが入力されていません"
                            isError = true
                            isShowAlert = true
                        } else if password.isEmpty {
                            errorMessage = "パスワードが入力されていません"
                            isError = true
                            isShowAlert = true
                        } else {
                            signIn()
                        }
                    }){
                        ButtonView(text: "ログイン").padding(.top, 20)
                    }
                    .alert(isPresented: $isShowAlert) {
                        if isError {
                            return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK"))
                            )
                        } else {
                            return Alert(title: Text(""), message: Text("ログインしました"), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }.padding(20)
            }
        }.onAppear {
            
        }
    }
    
    private func getCurrentUser() {
        if let _ = Auth.auth().currentUser {
            isSignedIn = true
        } else {
            isSignedIn = false
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                isSignedIn = true
                isShowAlert = true
                isError = false
            } else {
                isSignedIn = false
                isShowAlert = true
                isError = true
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
                    
                    isError = true
                    isShowAlert = true
                }
            }
        }
    }
}
