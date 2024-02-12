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
        SimpleNavigationView(title: String(localized: "changeInfoViewTitle")) {
            ZStack{
                //背景タップでキーボードを閉じる
                Color("ClearColor")
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = nil
                    }
                VStack(spacing: 0){
                    //メールアドレスtextField
                    TextFieldView(title: "newEmailAddress", text: $email, placeHolder: "emailAddressPlaceholder", isSecure: false)
                        .focused($focus, equals: .email)
                    //メールアドレス変更ボタン
                    Button( action: {
                        if email.isEmpty {
                            error = String(localized: "emailIsEmpty")
                        } else {
                            error = firebaseViewModel.changeEmail(into: email) ?? ""
                        }
                        isShowingEmailAlert = true
                    }, label: {
                        ButtonView("changeEmail").padding(.vertical, 20)
                    })
                    .alert(isPresented: $isShowingEmailAlert) {
                        if error.isEmpty {
                            return Alert(title: Text("updatedEmail"), message: Text(""), dismissButton: .default(Text("ok"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text("ok")))
                        }
                    }
                    //パスワード変更フォーム
                    TextFieldView(title: "newPassword", text: $password, placeHolder: "passwordPlaceholder", isSecure: true)
                        .focused($focus, equals: .password)
                    TextFieldView(title: "passwordConfirm", text: $confirm, placeHolder: "passwordPlaceholder", isSecure: true)
                        .focused($focus, equals: .confirm)
                    //パスワード変更ボタン
                    Button( action: {
                        if password.isEmpty {
                            error = String(localized: "passwordIsEmpty")
                        } else if confirm.isEmpty {
                            error = String(localized: "passwordConfirmIsEmpty")
                        } else if password.compare(self.confirm) != .orderedSame {
                            error = String(localized: "passwordAndPasswordConfirmIsNotEqual")
                        } else {
                            error = firebaseViewModel.changePassword(into: password) ?? ""
                        }
                        isShowingPasswordAlert = true
                    }, label: {
                        ButtonView("changePassword").padding(.top, 20)
                    })
                    .alert(isPresented: $isShowingPasswordAlert) {
                        if error.isEmpty {
                            return Alert(title: Text("passwordUpdated"), message: Text(""), dismissButton: .default(Text("ok"), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text("ok")))
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
