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
    var recordingEvent: Event
    var body: some View {
        VStack{
            HStack{
                Text("重量").fontWeight(.bold)
                Picker("weight", selection: $weight, content: {
                    ForEach(1..<500) { num in
                        Text(String(num)).font(.headline)
                    }
                })
                .frame(width: 100, height: 150)
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
                .frame(width: 100, height: 150)
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Text("rep").fontWeight(.bold)
            }
            Button( action: {
                model.updateRecord(event: recordingEvent, weight: weight + 1, rep: rep + 1)
                dismiss()
            }, label: {
                Text("完了")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(10)
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

//struct RecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordView()
//    }
//}
