//
//  EditView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/05.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    var event: Event
    var body: some View {
        SimpleNavigationView(title: "種目を編集") {
            VStack{
                TextFieldView(title: "種目名", text: $name, placeHolder: "種目名を入力してください")
                    .onAppear{
                        self.name = event.id
                    }
                Button( action: {
                    viewModel.updateEvent(event: event, newName: name)
                    dismiss()
                }, label: {
                    ButtonView(text: "名前を上書き").padding(10)
                })
                Button( action: {
                    viewModel.deleteEvent(event: event)
                    dismiss()
                }, label: {
                    Text("種目を削除")
                        .fontWeight(.bold)
                        .frame(width: 300, height: 70, alignment: .center)
                        .foregroundColor(viewModel.getThemeColor())
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 3)
                            .foregroundColor(viewModel.getThemeColor())
                        )
                })
                Spacer()
            }.padding(20)

        }
    }
}
