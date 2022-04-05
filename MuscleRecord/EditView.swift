//
//  EditView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/05.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var model = ViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    var event: Event
    var body: some View {
        VStack{
            HStack{
                Text("種目名")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("FontColor"))
                    .padding(.top, 30)
                Spacer()
            }.frame(width: 300, height: 70, alignment: .center)
            TextField("種目名を入力してください", text: $name)
                .font(.headline)
                .frame(width: 300, height: 70, alignment: .center)
                .onAppear{
                    self.name = event.name
                }
            Button( action: {
                model.updateEvent(event: event, newName: name)
                dismiss()
            }, label: {
                Text("名前を上書き")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(10)
            })
            Button( action: {
                model.deleteEvent(event: event)
                dismiss()
            }, label: {
                Text("種目を削除")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 3))
            })
            Spacer()
        }
        .navigationTitle("種目を編集")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                        }
                    ).tint(.white)
                }
            }    }
}
