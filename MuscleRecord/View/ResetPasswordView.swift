//
//  ResetPasswordView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/22.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Bool
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isSignedIn = false
    @State private var isShowingAlert = false
    
    var body: some View {
        ZStack{
            //背景タップでキーボードを閉じる
            viewModel.clearColor
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = false
                }
            VStack(spacing: 0){
                //タイトル
                Text("パスワードを再設定")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                //メールアドレスtextField
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus)
                //パスワード再設定ボタン
                Button( action: {
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = "メールアドレスが入力されていません"
                    } else {
                        firebaseViewModel.resetPassword(email: email)
                    }
                    isShowingAlert = true
                }){
                    ButtonView(text: "パスワードを再設定").padding(.top, 20)
                }
                .alert(isPresented: $isShowingAlert) {
                    if errorMessage.isEmpty {
                        return Alert(title: Text("メールを送信しました"), message: Text("受け取ったメールを開いてパスワードを再設定してください。"), dismissButton: .default(Text("OK"), action: {
                            dismiss()
                        }))
                    } else {
                        return Alert(title: Text("エラー"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
