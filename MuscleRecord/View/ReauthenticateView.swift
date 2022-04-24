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
    @State private var showResetPassword = false
    @State private var showChangeInfo = false
    @State private var isShowAlert = false
    @State private var errorMessage = ""
    
    enum Focus {
        case email, password
    }
    
    var body: some View {
        ZStack{
            viewModel.clearColor
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                Text("ログイン")
                    .font(.headline)
                    .padding(.bottom, 10)
                    .foregroundColor(viewModel.fontColor)
                Text("アカウント情報を変更するには一度ログインする必要があります。")
                    .font(.body)
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                    .multilineTextAlignment(.center)
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                Button( action: {
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = "メールアドレスが入力されていません"
                        isShowAlert = true
                    } else if password.isEmpty {
                        errorMessage = "パスワードが入力されていません"
                        isShowAlert = true
                    } else {
                        signIn()
                    }
                }){
                    ButtonView(text: "ログイン").padding(.top, 20)
                }
                .sheet(isPresented: $showChangeInfo) {
                    ChangeInfoView()
                }
                Button {
                    showResetPassword = true
                } label: {
                    Text("パスワードを忘れた")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                .sheet(isPresented: $showResetPassword) {
                    ResetPasswordView()
                }
                .alert(isPresented: $isShowAlert) {
                    return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK")))
                }
                Spacer()
            }.padding(20)
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                showChangeInfo = true
            } else {
                isShowAlert = true
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
                    isShowAlert = true
                }
            }
        }
    }
}
