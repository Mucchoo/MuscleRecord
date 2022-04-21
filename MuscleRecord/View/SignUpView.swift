//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/21.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @State private var adress = ""
    var body: some View {
        SimpleNavigationView(title: "アカウント作成") {
            VStack(spacing: 0){
                TextFieldView(title: "メールアドレス", text: $adress, placeHolder: "example@example.com")
                Button( action: {
                    dismiss()
                }, label: {
                    ButtonView(text: "アカウント作成").padding(.top, 20)
                })
                Spacer()
            }.padding(20)
        }
    }
}
