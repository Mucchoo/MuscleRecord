//
//  ChangeAccountView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/24.
//

import SwiftUI
import Firebase

struct ChangeInfoView: View {
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var showEmailAlert = false
    @State private var showPasswordAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    enum Focus {
        case email, password, confirm
    }
    
    var body: some View {
        SimpleNavigationView(title: "アカウント情報変更") {
            ZStack{
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = nil
                    }
                VStack(spacing: 0){
                    TextFieldView(title: "新しいメールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                        .focused($focus, equals: .email)
                    Button( action: {
                        if email.isEmpty {
                            showEmailAlert = true
                            isError = true
                            errorMessage = "メールアドレスが入力されていません"
                        } else {
                            Auth.auth().currentUser?.updateEmail(to: email) { error in
                                showEmailAlert = true
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
                    }, label: {
                        ButtonView(text: "メールアドレスを変更").padding(.vertical, 20)
                    })
                    .alert(isPresented: $showEmailAlert) {
                        if isError {
                            return Alert(title: Text(errorMessage), message: Text(""), dismissButton: .default(Text("OK")))
                        } else {
                            return Alert(title: Text("メールアドレスが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                window?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        }
                    }
                    TextFieldView(title: "新しいパスワード", text: $password, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .password)
                    TextFieldView(title: "確認用パスワード", text: $confirm, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .confirm)
                    Button( action: {
                        if password.isEmpty {
                            showPasswordAlert = true
                            isError = true
                            errorMessage = "パスワードが入力されていません"
                        } else if confirm.isEmpty {
                            showPasswordAlert = true
                            isError = true
                            errorMessage = "確認パスワードが入力されていません"
                        } else if password.compare(self.confirm) != .orderedSame {
                            showPasswordAlert = true
                            isError = true
                            errorMessage = "パスワードと確認パスワードが一致しません"
                        } else {
                            Auth.auth().currentUser?.updatePassword(to: password) { error in
                                showPasswordAlert = true
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
                    }, label: {
                        ButtonView(text: "パスワードを変更").padding(.top, 20)
                    })
                    .alert(isPresented: $showPasswordAlert) {
                        if isError {
                            return Alert(title: Text(errorMessage), message: Text(""), dismissButton: .default(Text("OK")))
                        } else {
                            return Alert(title: Text("パスワードが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                window?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
