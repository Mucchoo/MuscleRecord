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
            VStack(spacing: 0){
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
                    .focused($focus)
                    .frame(width: 300, height: 100, alignment: .center)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.focus = true
                        }
                    }
                Button( action: {
                    viewModel.addEvent(name)
                    self.focus = false
                    self.name = ""
                    print("ででええええええええ")
                    dismiss()
                }, label: {
                    ButtonView(text: "追加").padding(.top, 30)
                })
                Spacer()
            }
        }
    }
}
