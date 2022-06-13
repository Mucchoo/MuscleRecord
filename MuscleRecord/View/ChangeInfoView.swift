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
        SimpleNavigationView(title: R.string.localizable.changeInfoViewTitle()) {
            ZStack{
                //背景タップでキーボードを閉じる
                Color(R.color.clearColor()!)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = nil
                    }
                VStack(spacing: 0){
                    //メールアドレスtextField
                    TextFieldView(title: R.string.localizable.newEmailAddress(), text: $email, placeHolder: R.string.localizable.emailAddressPlaceholder(), isSecure: false)
                        .focused($focus, equals: .email)
                    //メールアドレス変更ボタン
                    Button( action: {
                        if email.isEmpty {
                            error = R.string.localizable.emailIsEmpty()
                        } else {
                            error = firebaseViewModel.changeEmail(into: email) ?? ""
                        }
                        isShowingEmailAlert = true
                    }, label: {
                        ButtonView(text: R.string.localizable.changeEmail()).padding(.vertical, 20)
                    })
                    .alert(isPresented: $isShowingEmailAlert) {
                        if error.isEmpty {
                            return Alert(title: Text(R.string.localizable.updatedEmail()), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok()), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok())))
                        }
                    }
                    //パスワード変更フォーム
                    TextFieldView(title: R.string.localizable.newPassword(), text: $password, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                        .focused($focus, equals: .password)
                    TextFieldView(title: R.string.localizable.passwordConfirm(), text: $confirm, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                        .focused($focus, equals: .confirm)
                    //パスワード変更ボタン
                    Button( action: {
                        if password.isEmpty {
                            error = R.string.localizable.passwordIsEmpty()
                        } else if confirm.isEmpty {
                            error = R.string.localizable.passwordConfirmIsEmpty()
                        } else if password.compare(self.confirm) != .orderedSame {
                            error = R.string.localizable.passwordAndPasswordConfirmIsNotEqual()
                        } else {
                            error = firebaseViewModel.changePassword(into: password) ?? ""
                        }
                        isShowingPasswordAlert = true
                    }, label: {
                        ButtonView(text: R.string.localizable.changePassword()).padding(.top, 20)
                    })
                    .alert(isPresented: $isShowingPasswordAlert) {
                        if error.isEmpty {
                            return Alert(title: Text(R.string.localizable.passwordUpdated()), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok()), action: {
                                Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            }))
                        } else {
                            return Alert(title: Text(error), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok())))
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
