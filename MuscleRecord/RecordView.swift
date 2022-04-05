//
//  InputView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = ViewModel()
    @State private var weight = 4
    @State private var rep = 4
    var event: Event
    var body: some View {
        VStack{
            HStack{
                Text("重量").fontWeight(.bold)
                Picker("weight", selection: $weight, content: {
                    ForEach(1..<500) { num in
                        Text(String(num)).font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Text("kg ").fontWeight(.bold)
            }
            HStack{
                Text("回数").fontWeight(.bold)
                Picker("rep", selection: $rep, content: {
                    ForEach(1..<300) { num in
                        Text(String(num)).font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Text("rep").fontWeight(.bold)
            }
            Button( action: {
                model.updateRecord(event: event, weight: weight + 1, rep: rep + 1)
                dismiss()
            }, label: {
                Text("記録")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(10)
            })
            Spacer()
        }
        .navigationTitle(event.name)
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
