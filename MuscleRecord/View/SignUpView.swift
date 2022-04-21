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
    @FocusState private var focus: Bool
    @State private var adress = ""
    var body: some View {
        SimpleNavigationView(title: "アカウント作成") {
            ZStack{
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.focus = false
                    }
                VStack(spacing: 0){
                    TextFieldView(title: "メールアドレス", text: $adress, placeHolder: "example@example.com")
                        .focused($focus)
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
}
