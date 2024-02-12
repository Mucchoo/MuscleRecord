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
            Color("ClearColor")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = false
                }
            VStack(spacing: 0){
                //タイトル
                Text("resetPassword")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(Color("FontColor"))
                //メールアドレスtextField
                TextFieldView(title: "emailAddress", text: $email, placeHolder: "emailAddressPlaceholder", isSecure: false)
                    .focused($focus)
                //パスワード再設定ボタン
                Button( action: {
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = String(localized: "emailIsEmpty")
                    } else {
                        firebaseViewModel.resetPassword(email: email)
                    }
                    isShowingAlert = true
                }){
                    ButtonView("resetPassword").padding(.top, 20)
                }
                .alert(isPresented: $isShowingAlert) {
                    if errorMessage.isEmpty {
                        return Alert(title: Text("sendEmail"), message: Text("pleaseCheckEmail"), dismissButton: .default(Text("ok"), action: {
                            dismiss()
                        }))
                    } else {
                        return Alert(title: Text("errorOccured"), message: Text(errorMessage), dismissButton: .default(Text("ok")))
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
