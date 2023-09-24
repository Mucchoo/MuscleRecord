//
//  ChangeAccountView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/24.
//

import SwiftUI

struct ChangeInfoView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var error = ""
    @State private var email = ""
    @State private var confirm = ""
    @State private var password = ""
    @State private var isShowingEmailAlert = false
    @State private var isShowingPasswordAlert = false
    
    enum Focus {
        case email, password, confirm
    }
    
    var body: some View {
        SimpleNavigationView(title: "アカウント情報変更") {
            ZStack{
                //背景タップでキーボードを閉じる
                Color("ClearColor")
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
                            error = "メールアドレスが入力されていません"
                        } else {
                            error = firebaseViewModel.changeEmail(into: email) ?? ""
                        }
                        isShowingEmailAlert = true
                    }, label: {
                        ButtonView(text: "メールアドレスを変更").padding(.vertical, 20)
                    })
                    .alert(isPresented: $isShowingEmailAlert) {
                        if error.isEmpty {
                            return Alert(title: Text("メールアドレスが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text("OK")))
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
                            error = "パスワードが入力されていません"
                        } else if confirm.isEmpty {
                            error = "確認用パスワードが入力されていません"
                        } else if password.compare(self.confirm) != .orderedSame {
                            error = "パスワードと確認パスワードが一致しません"
                        } else {
                            error = firebaseViewModel.changePassword(into: password) ?? ""
                        }
                        isShowingPasswordAlert = true
                    }, label: {
                        ButtonView(text: "パスワードを変更").padding(.top, 20)
                    })
                    .alert(isPresented: $isShowingPasswordAlert) {
                        if error.isEmpty {
                            return Alert(title: Text("パスワードが更新されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
