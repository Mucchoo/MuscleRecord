//
//  InputView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @State private var weight = 0
    @State private var rep = 0
    var event: Event
    var body: some View {
        SimpleNavigationView(title: event.id) {
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
                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                        viewModel.updateRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                    } else {
                        viewModel.addRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                    }
                    dismiss()
                }, label: {
                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                        ButtonView(text: "記録を上書き")
                    } else {
                        ButtonView(text: "記録")
                    }
                })
                Spacer()
            }.padding(20)
        }
    }
}
