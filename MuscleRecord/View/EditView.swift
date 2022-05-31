//
//  EditView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/05.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Bool
    @State private var itemName = ""
    @State private var showAlert = false
    var event: Event
    
    var body: some View {
        SimpleNavigationView(title: "種目を編集") {
            ZStack{
                //背景タップ時にキーボードを閉じる
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.focus = false
                    }
                VStack(spacing: 0){
                    //種目名textfield
                    TextFieldView(title: "種目名", text: $itemName, placeHolder: "種目名を入力してください", isSecure: false)
                        .focused($focus)
                        .onAppear{
                            self.itemName = event.name
                        }
                    //上書きボタン
                    Button( action: {
                        viewModel.updateEvent(event: event, newName: itemName)
                        dismiss()
                    }){
                        ButtonView(text: "名前を上書き")
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                    }
                    //削除ボタン
                    Button( action: {
                        showAlert = true
                    }){
                        Text("種目を削除")
                            .fontWeight(.bold)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 70, alignment: .center)
                            .background(viewModel.clearColor)
                            .foregroundColor(viewModel.getThemeColor())
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    //削除時のアラート
                    .alert(isPresented: $showAlert) {
                        return Alert(title: Text("本当に削除しますか？"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("削除"), action: {
                            viewModel.deleteEvent(event: event)
                            dismiss()
                        }))
                    }
                    Spacer()
                }.padding(20)
            }
        }
    }
}
