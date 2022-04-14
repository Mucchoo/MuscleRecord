//
//  InputView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = FirebaseModel()
    @State private var weight = 0
    @State private var rep = 0
    @State var viewModel = ViewModel()
    var event: Event
    var body: some View {
        VStack{
            HStack{
                Text("重量").fontWeight(.bold)
                Picker("weight", selection: $weight, content: {
                    ForEach(1..<1001) { num in
                        Text(String(Float(num)/2)).font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    weight = Int(event.latestWeight*2) - 1
                }
                Text("kg ").fontWeight(.bold)
            }
            HStack{
                Text("回数").fontWeight(.bold)
                Picker("rep", selection: $rep, content: {
                    ForEach(1..<100) { num in
                        Text(String(num)).font(.headline)
                    }
                })
                .frame(width: 100)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    rep = event.latestRep - 1
                }
                Text("rep").fontWeight(.bold)
            }
            Button( action: {
                if model.dateFormat(date: Date()) == model.dateFormat(date: event.latestDate) {
                    model.updateRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                } else {
                    model.addRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                }
                dismiss()
            }, label: {
                if model.dateFormat(date: Date()) == model.dateFormat(date: event.latestDate) {
                    Text("記録を上書きする")
                        .fontWeight(.bold)
                        .frame(width: 300, height: 70, alignment: .center)
                        .background(viewModel.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .padding(10)
                } else {
                    Text("記録")
                        .fontWeight(.bold)
                        .frame(width: 300, height: 70, alignment: .center)
                        .background(viewModel.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .padding(10)
                }
            })
            Spacer()
        }
        .navigationTitle(event.id)
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
