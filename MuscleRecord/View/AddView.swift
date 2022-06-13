//
//  AddView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/30.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @FocusState private var isFocused: Bool
    @State private var eventName = ""
    
    var body: some View {
        SimpleNavigationView(title: R.string.localizable.addViewTitle()) {
            ZStack{
                //背景タップ時にキーボードを閉じる
                Color(R.color.clearColor()!)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isFocused = false
                    }
                VStack(spacing: 0){
                    //種目名textField
                    TextFieldView(title: R.string.localizable.eventName(), text: $eventName, placeHolder: R.string.localizable.eventNamePlaceholder(), isSecure: false)
                        .focused($isFocused)
                    //種目追加ボタン
                    Button( action: {
                        firebaseViewModel.addEvent(eventName)
                        isFocused = false
                        eventName = ""
                        dismiss()
                    }, label: {
                        ButtonView(text: R.string.localizable.add())
                            .padding(.top, 20)
                    })
                    Spacer()
                }
                .padding(20)
            }
        }.onAppear {
            //遷移後の自動フォーカス
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
}
