//
//  ResetPasswordView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var focus: Bool
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isSignedIn = false
    @State private var isShowingAlert = false
    
    var body: some View {
        ZStack{
            //背景タップでキーボードを閉じる
            Color(R.color.clearColor()!)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = false
                }
            VStack(spacing: 0){
                //タイトル
                Text(R.string.localizable.resetPassword())
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(R.color.fontColor()!))
                //メールアドレスtextField
                TextFieldView(title: R.string.localizable.emailAddress(), text: $email, placeHolder: R.string.localizable.emailAddressPlaceholder(), isSecure: false)
                    .focused($focus)
                //パスワード再設定ボタン
                Button( action: {
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = R.string.localizable.emailIsEmpty()
                    } else {
                        firebaseViewModel.resetPassword(email: email)
                    }
                    isShowingAlert = true
                }){
                    ButtonView(text: R.string.localizable.resetPassword()).padding(.top, 20)
                }
                .alert(isPresented: $isShowingAlert) {
                    if errorMessage.isEmpty {
                        return Alert(title: Text(R.string.localizable.sendEmail()), message: Text(R.string.localizable.pleaseCheckEmail()), dismissButton: .default(Text(R.string.localizable.ok()), action: {
                            dismiss()
                        }))
                    } else {
                        return Alert(title: Text(R.string.localizable.errorOccured()), message: Text(errorMessage), dismissButton: .default(Text(R.string.localizable.ok())))
                    }
                }
                Spacer()
            }.padding(20)
        //自動フォーカス
        }.onAppear {
            focus = true
        }
    }
}
