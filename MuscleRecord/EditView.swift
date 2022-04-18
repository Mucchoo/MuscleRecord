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
                HStack{
                    Text("種目名")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.fontColor)
                        .padding(.top, 30)
                    Spacer()
                }.frame(width: 300, height: 70, alignment: .center)
                TextField("種目名を入力してください", text: $name)
                    .font(.headline)
                    .frame(width: 300, height: 70, alignment: .center)
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
            }

        }
    }
}
