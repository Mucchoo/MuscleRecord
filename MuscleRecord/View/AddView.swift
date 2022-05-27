//
//  AddView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/30.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Bool
    @State private var name = ""
    
    var body: some View {
        SimpleNavigationView(title: "種目を追加") {
            ZStack{
                //背景タップ時にキーボードを閉じる
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = false
                    }
                VStack(spacing: 0){
                    //種目名textField
                    TextFieldView(title: "種目名", text: $name, placeHolder: "種目名を入力してください", isSecure: false)
                        .focused($focus)
                    //種目追加ボタン
                    Button( action: {
                        viewModel.addEvent(name)
                        focus = false
                        name = ""
                        dismiss()
                    }, label: {
                        ButtonView(text: "追加")
                            .padding(.top, 20)
                    })
                    Spacer()
                }
                .padding(20)
            }
        }.onAppear {
            //遷移後の自動フォーカス
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focus = true
            }
        }
    }
}
