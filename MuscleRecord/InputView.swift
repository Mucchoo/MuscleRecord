//
//  InputView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct InputView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            HStack{
                Text("重量").fontWeight(.bold)
                Picker("種目", selection: .constant(1), content: {
                    ForEach(0..<30) { num in
                        Text("500").font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Text("kg ").fontWeight(.bold)
            }
            HStack{
                Text("回数").fontWeight(.bold)
                Picker("種目", selection: .constant(1), content: {
                    ForEach(0..<30) { num in
                        Text("100").font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Text("rep").fontWeight(.bold)
            }
            Button( action: {dismiss()}, label: {
                Text("完了")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            })
            Spacer()
        }
            .navigationTitle("今日の記録を入力")
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

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
