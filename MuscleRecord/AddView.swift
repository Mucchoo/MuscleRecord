//
//  AddView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/30.
//

import SwiftUI

struct MyTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var becomeFirstResponder: Bool

    func makeUIView(context: Context) -> UITextField {
        return UITextField()
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        if self.becomeFirstResponder {
            DispatchQueue.main.async {
                textField.becomeFirstResponder()
                self.becomeFirstResponder = false
            }
        }
    }
}

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var event = ""
    @State private var becomeFirstResponder = false
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text("種目名")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("FontColor"))
                    .padding(.top, 30)
                Spacer()
            }.frame(width: 300, height: 70, alignment: .center)
            MyTextField(becomeFirstResponder: self.$becomeFirstResponder)
                .onAppear{
                    self.becomeFirstResponder = true
                }
                .frame(width: 300, height: 70, alignment: .center)
            Button( action: {dismiss()}, label: {
                Text("追加する")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Color("AccentColor"))
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
