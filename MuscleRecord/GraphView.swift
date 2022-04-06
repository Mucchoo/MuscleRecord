//
//  GraphView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

//func createBar(newRecord: Record, oldRecord: Record) {
//    @ObservedObject var model = ViewModel()
//    let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "M/d"
//        return dateFormatter
//    }()
//    var modifiedDate = Date(timeInterval: 60*60*24, since: oldRecord.date)
//    while modifiedDate != newRecord.date {
//        VStack(spacing: 0){
//            GeometryReader { geometry in
//                VStack(spacing: 0) {
//                    Rectangle()
//                        .frame(minHeight: 0, maxHeight: .infinity)
//                        .foregroundColor(Color("ClearColor"))
//                    Rectangle()
//                        .frame(width: 30, height: geometry.size.height * CGFloat(oldRecord.weight/model.maxWeight))
//                        .foregroundColor(Color("AccentColor"))
//                }
//            }
//            Text(String(oldRecord.rep))
//                .foregroundColor(.white)
//                .padding(.bottom, 5)
//                .frame(width: 30, height: 30)
//                .background(Color("AccentColor"))
//            Rectangle()
//                .frame(width: 40, height: 3)
//                .foregroundColor(Color("AccentColor"))
//            Text(dateFormatter.string(from: modifiedDate))
//                .frame(width: 34)
//                .foregroundColor(Color("AccentColor"))
//                .font(.footnote)
//                .padding(.bottom, 10)
//                .padding(.top, 4)
//        }
//        modifiedDate = Date(timeInterval: 60*60*24, since: modifiedDate)
//    }
//}

struct GraphView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = ViewModel()
    @State var selectedIndex = 0
    var indexArray: [Float] = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
    var event: Event
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("period", selection: self.$selectedIndex, content: {
                Text("毎日").tag(0)
                Text("3日平均").tag(1)
                Text("週平均").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
            HStack(spacing: 0) {
                VStack(spacing:0) {
                    ForEach(indexArray, id: \.self) { index in
                        Text(String(format: "%.0f", model.maxWeight * index))
                            .foregroundColor(Color("AccentColor"))
                            .font(.footnote)
                        Spacer()
                    }
                    Text("0")
                        .foregroundColor(Color("AccentColor"))
                        .font(.footnote)
                }
                .offset(y: 8)
                .frame(minWidth: 15, minHeight: 0, maxHeight: .infinity)
                .padding(.bottom, 63)
                .padding(.trailing, 10)
                .padding(.top, 22)
                Rectangle()
                .foregroundColor(Color("AccentColor"))
                .frame(width: 3)
                .padding(.bottom, 30)
                ScrollViewReader{ proxy in
                    ScrollView(.horizontal){
                        HStack(alignment: .bottom, spacing: 0) {
                            
                            ForEach(model.records) { record in
//                                if let oldRecord = model.oldRecord {
//                                    ForEach(0..<Int((record.date.timeIntervalSince(oldRecord.date))) { num in
//                                        Text(String(num))
//                                    }
//                                }
//                                    ForEach(Date(timeInterval: -60*60*24, since: record.date).timeIntervalSince(oldRecord.date)/60*60*24) { num in
//                                        Text(String(num))
//                                    }
                                //1.oldRecordがnilではないことを確認
                                //2.oldRecord.date+1とrecord.dateが等しくなるまで3,4をループ
                                //3.oldRecord.dateに1日加算
                                //4.oldRecordを元にグラフを1本作成
                                //5.oldRecordにrecordを代入
                                
                                VStack(spacing: 0){
                                    GeometryReader { geometry in
                                        VStack(spacing: 0) {
                                            Rectangle()
                                                .frame(minHeight: 0, maxHeight: .infinity)
                                                .foregroundColor(Color("ClearColor"))
                                            Rectangle()
                                                .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/model.maxWeight))
                                                .foregroundColor(Color("AccentColor"))
                                        }
                                    }
                                    Text(String(record.rep))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                        .frame(width: 30, height: 30)
                                        .background(Color("AccentColor"))
                                    Rectangle()
                                        .frame(width: 40, height: 3)
                                        .foregroundColor(Color("AccentColor"))
                                    Text(dateFormatter.string(from: record.date))
                                        .frame(width: 34)
                                        .foregroundColor(Color("AccentColor"))
                                        .font(.footnote)
                                        .padding(.bottom, 10)
                                        .padding(.top, 4)
                                        .id(record.id)
                                }
//                                .onAppear{
//                                    model.oldRecord = record
//                                }
                            }
                            .padding(.top, 38)
                            .onAppear{
                                proxy.scrollTo(model.latestID)
                            }
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(10)
        .onAppear {
            model.getEvent()
            model.getRecord(event: event)
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
