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
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(viewModel.fontColor)
            .padding(10)
        TextField(placeHolder, text: text)
            .font(.headline)
            .frame(height: 50, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(viewModel.getThemeColor(), lineWidth: 3))
            .multilineTextAlignment(.center)
    }
}
