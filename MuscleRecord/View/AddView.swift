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
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.focus = false
                    }
                VStack(spacing: 0){
                    TextFieldView(title: "種目名", text: $name, placeHolder: "種目名を入力してください")
                        .focused($focus)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.focus = true
                            }
                        }
                    Button( action: {
                        viewModel.addEvent(name)
                        self.focus = false
                        self.name = ""
                        dismiss()
                    }, label: {
                        ButtonView(text: "追加").padding(.top, 20)
                    })
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
