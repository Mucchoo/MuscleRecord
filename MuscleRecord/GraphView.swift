//
//  GraphView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

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
                Text("1週間").tag(0)
                Text("1ヶ月").tag(1)
                Text("3ヶ月").tag(2)
                Text("6ヶ月").tag(3)
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
                                        .frame(width: 30, height: 15)
                                        .background(Color("AccentColor"))
                                    Text("rep")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .frame(width: 30, height: 10)
                                        .padding(.bottom, 5)
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
