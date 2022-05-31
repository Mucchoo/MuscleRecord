//
//  TextFieldView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/21.
//

import SwiftUI

struct TextFieldView: View {
    @ObservedObject var viewModel = ViewModel()
    var title: String
    var text: Binding<String>
    var placeHolder: String
    var isSecure: Bool
    //アプリ全体で使うtextField
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(viewModel.fontColor)
                .padding(.leading, 8)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 5)
        if isSecure {
            SecureField(placeHolder, text: text)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .frame(height: 50, alignment: .center)
                .background(viewModel.getThemeColor().opacity(0.1))
                .cornerRadius(8)
        } else {
            TextField(placeHolder, text: text)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .frame(height: 50, alignment: .center)
                .background(viewModel.getThemeColor().opacity(0.1))
                .cornerRadius(8)
        }
    }
}
