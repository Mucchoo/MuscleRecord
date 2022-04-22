//
//  UpdateAuthView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import SwiftUI
import Firebase

struct UpdateAuthView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    
    @State private var isShowEmailUpdateAlert = false
    @State private var isShowPasswordUpdateAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    var body: some View {
        SimpleNavigationView(title: "アカウント情報変更") {
            VStack {
                Text("新しいメールアドレス")
                TextField("mail@example.com", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if email.isEmpty {
                        isShowEmailUpdateAlert = true
                        isError = true
                        errorMessage = "メールアドレスが入力されていません"
                    } else {
                        Auth.auth().currentUser?.updateEmail(to: email) { error in
                            isShowEmailUpdateAlert = true
                            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                switch errorCode {
                                case .invalidEmail:
                                    errorMessage = "メールアドレスの形式が正しくありません"
                                case .requiresRecentLogin:
                                    errorMessage = "ログインしてください"
                                default:
                                    errorMessage = error.localizedDescription
                                }
                                isError = true
                            } else {
                                isError = false
                            }
                        }
                    }
                }) {
                    Text("メールアドレス変更")
                }
                .alert(isPresented: $isShowEmailUpdateAlert) {
                    if isError {
                        return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("メールアドレスが更新されました"), dismissButton: .default(Text("OK")))
                    }
                }
                Spacer().frame(height: 50)
                Text("新しいパスワード")
                SecureField("半角英数字", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("パスワード確認")
                SecureField("半角英数字", text: $confirm).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if self.password.isEmpty {
                        isShowPasswordUpdateAlert = true
                        isError = true
                        errorMessage = "パスワードが入力されていません"
                    } else if self.confirm.isEmpty {
                        isShowPasswordUpdateAlert = true
                        isError = true
                        errorMessage = "確認パスワードが入力されていません"
                    } else if self.password.compare(self.confirm) != .orderedSame {
                        isShowPasswordUpdateAlert = true
                        isError = true
                        errorMessage = "パスワードと確認パスワードが一致しません"
                    } else {
                        Auth.auth().currentUser?.updatePassword(to: password) { error in
                            isShowPasswordUpdateAlert = true
                            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                switch errorCode {
                                case .weakPassword:
                                    errorMessage = "パスワードは６文字以上で入力してください"
                                case .requiresRecentLogin:
                                    errorMessage = "ログインしてください"
                                default:
                                    errorMessage = error.localizedDescription
                                }
                                isError = true
                            } else {
                                isError = false
                            }
                        }
                    }
                }) {
                    Text("パスワード変更")
                }
                .alert(isPresented: $isShowPasswordUpdateAlert) {
                    if isError {
                        return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("パスワードが更新されました"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            Spacer()
        }
    }
}
