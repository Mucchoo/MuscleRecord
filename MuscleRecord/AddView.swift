//
//  AddView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/30.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = FirebaseModel()
    @FocusState private var focus: Bool
    @State private var name = ""
    @State var viewModel = ViewModel()
    var body: some View {
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
                model.addEvent(name)
                self.focus = false
                self.name = ""
                print("ででええええええええ")
                dismiss()
            }, label: {
                Text("追加")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(viewModel.themeColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.top, 30)
            })
            Spacer()
        }
        .navigationTitle("種目を追加")
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
        }
    }
}
