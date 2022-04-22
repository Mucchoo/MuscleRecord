//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/21.
//

import Firebase
import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""

    enum Focus {
        case email, password, passwordConfirm
    }
    
    var body: some View {
        SimpleNavigationView(title: "アカウント作成") {
            ZStack{
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.focus = nil
                    }
                VStack(spacing: 0){
                    TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                        .focused($focus, equals: .email)
                    TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .password)
                    TextFieldView(title: "確認用パスワード", text: $passwordConfirm, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .passwordConfirm)
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
                        } else if passwordConfirm.isEmpty {
                            errorMessage = "確認用パスワードが入力されていません"
                            isError = true
                            isShowAlert = true
                        } else if password.compare(passwordConfirm) != .orderedSame {
                            errorMessage = "パスワードと確認パスワードが一致しません"
                            isError = true
                            isShowAlert = true
                        } else {
                            signUp()
                        }
                    }){
                        ButtonView(text: "アカウント作成").padding(.top, 20)
                    }
                    Button(action: {
                        Auth.auth().sendPasswordReset(withEmail: email) { error in }
                    }){
                        Text("パスワード再設定")
                            .font(.headline)
                            .foregroundColor(viewModel.getThemeColor())
                            .padding(20)
                    }
                    .alert(isPresented: $isShowAlert) {
                        if self.isError {
                            return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"))
                            )
                        } else {
                            return Alert(title: Text(""), message: Text("登録されました"), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }.padding(20)
            }
        }
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    errorMessage = "メールアドレスの形式が正しくありません"
                case .emailAlreadyInUse:
                    errorMessage = "このメールアドレスは既に登録されています"
                case .weakPassword:
                    errorMessage = "パスワードは６文字以上で入力してください"
                default:
                    errorMessage = error.domain
                }
                
                isError = true
                isShowAlert = true
            }
            
            if let _ = authResult?.user {
                isError = false
                isShowAlert = true
            }
            
            if let user = authResult?.user {
                user.sendEmailVerification(completion: { error in
                    if error == nil {
                        print("send mail success.")
                    }
                })
            }
        }
    }
}
