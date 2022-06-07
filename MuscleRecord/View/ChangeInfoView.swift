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
    @State private var confirm = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isError = false
    @State private var isShowingEmailAlert = false
    @State private var isShowingPasswordAlert = false
    
    enum Focus {
        case email, password, confirm
    }
    
    var body: some View {
        SimpleNavigationView(title: "アカウント情報変更") {
            ZStack{
                //背景タップでキーボードを閉じる
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = nil
                    }
                VStack(spacing: 0){
                    //メールアドレスtextField
                    TextFieldView(title: "新しいメールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                        .focused($focus, equals: .email)
                    //メールアドレス変更ボタン
                    Button( action: {
                        if email.isEmpty {
                            isShowingEmailAlert = true
                            isError = true
                            errorMessage = "メールアドレスが入力されていません"
                        } else {
                            Auth.auth().currentUser?.updateEmail(to: email) { error in
                                isShowingEmailAlert = true
                                if let error = error as NSError? {
                                    errorMessage = error.localizedDescription
                                    isError = true
                                } else {
                                    isError = false
                                }
                            }
                        }
                    }, label: {
                        ButtonView(text: "メールアドレスを変更").padding(.vertical, 20)
                    })
                    .alert(isPresented: $isShowingEmailAlert) {
                        //エラーアラート
                        if isError {
                            return Alert(title: Text(errorMessage), message: Text(""), dismissButton: .default(Text("OK")))
                        //成功アラート
                        } else {
                            return Alert(title: Text("メールアドレスが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        }
                    }
                    //パスワード変更フォーム
                    TextFieldView(title: "新しいパスワード", text: $password, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .password)
                    TextFieldView(title: "確認用パスワード", text: $confirm, placeHolder: "password", isSecure: true)
                        .focused($focus, equals: .confirm)
                    //パスワード変更ボタン
                    Button( action: {
                        if password.isEmpty {
                            isShowingPasswordAlert = true
                            isError = true
                            errorMessage = "パスワードが入力されていません"
                        } else if confirm.isEmpty {
                            isShowingPasswordAlert = true
                            isError = true
                            errorMessage = "確認パスワードが入力されていません"
                        } else if password.compare(self.confirm) != .orderedSame {
                            isShowingPasswordAlert = true
                            isError = true
                            errorMessage = "パスワードと確認パスワードが一致しません"
                        } else {
                            Auth.auth().currentUser?.updatePassword(to: password) { error in
                                isShowingPasswordAlert = true
                                if let error = error as NSError? {
                                    errorMessage = error.localizedDescription
                                    isError = true
                                } else {
                                    isError = false
                                }
                            }
                        }
                    }, label: {
                        ButtonView(text: "パスワードを変更").padding(.top, 20)
                    })
                    .alert(isPresented: $isShowingPasswordAlert) {
                        //エラーアラート
                        if isError {
                            return Alert(title: Text(errorMessage), message: Text(""), dismissButton: .default(Text("OK")))
                        //成功アラート
                        } else {
                            return Alert(title: Text("パスワードが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
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
