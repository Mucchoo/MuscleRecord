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
            Color(R.color.clearColor()!)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text(R.string.localizable.createAccount())
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(R.color.fontColor()!))
                //フォーム
                TextFieldView(title: R.string.localizable.emailAddress(), text: $email, placeHolder: R.string.localizable.emailAddressPlaceholder(), isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: R.string.localizable.password(), text: $password, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                    .focused($focus, equals: .password)
                TextFieldView(title: R.string.localizable.passwordConfirm(), text: $confirm, placeHolder: R.string.localizable.passwordPlaceholder(), isSecure: true)
                    .focused($focus, equals: .confirm)
                //アカウント作成ボタン
                Button( action: {
                    error = ""
                    if email.isEmpty {
                        error = R.string.localizable.emailIsEmpty()
                        isShowingAlert = true
                    } else if password.isEmpty {
                        error = R.string.localizable.passwordIsEmpty()
                        isShowingAlert = true
                    } else if confirm.isEmpty {
                        error = R.string.localizable.passwordConfirmIsEmpty()
                        isShowingAlert = true
                    } else if password.compare(confirm) != .orderedSame {
                        error = R.string.localizable.passwordAndPasswordConfirmIsNotEqual()
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
                    ButtonView(text: R.string.localizable.createAccount()).padding(.top, 20)
                }
                //ログインボタン
                Button {
                    showSignIn = true
                } label: {
                    Text(R.string.localizable.loginExistingAccount())
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                .alert(isPresented: $isShowingAlert) {
                    if error.isEmpty {
                        return Alert(title: Text(R.string.localizable.accountCreated()), message: Text(""), dismissButton: .default(Text(R.string.localizable.ok()), action: {
                            Window.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    } else {
                        return Alert(title: Text(""), message: Text(error), dismissButton: .destructive(Text(R.string.localizable.ok())))
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
