//
//  EditView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/05.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var isShowingAlert = false
    @FocusState private var isFocused: Bool
    @State private var itemName = ""
    var event: Event
    
    var body: some View {
        SimpleNavigationView(title: "種目を編集") {
            ZStack{
                //背景タップ時にキーボードを閉じる
                Color("ClearColor")
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isFocused = false
                    }
                VStack(spacing: 0){
                    //種目名textfield
                    TextFieldView(title: "種目名", text: $itemName, placeHolder: "種目名を入力してください", isSecure: false)
                        .focused($isFocused)
                        .onAppear{
                            itemName = event.name
                        }
                    //上書きボタン
                    Button( action: {
                        firebaseViewModel.updateEvent(event: event, newName: itemName)
                        dismiss()
                    }){
                        ButtonView(text: "名前を上書き")
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                    }
                    //削除ボタン
                    Button( action: {
                        isShowingAlert = true
                    }){
                        Text("種目を削除")
                            .fontWeight(.bold)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 70, alignment: .center)
                            .background(Color("ClearColor"))
                            .foregroundColor(viewModel.getThemeColor())
                            .cornerRadius(20)
                            .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                    //削除時のアラート
                    .alert(isPresented: $isShowingAlert) {
                        return Alert(title: Text("本当に削除しますか？"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("削除"), action: {
                            firebaseViewModel.deleteEvent(event: event)
                            dismiss()
                        }))
                    }
                    Spacer()
                }.padding(20)
            }
        }
    }
}
