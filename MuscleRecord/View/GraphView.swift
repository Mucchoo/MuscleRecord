//
//  GraphView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct GraphView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @State private var periodScale = 0
    private var weightScale: [Float] = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
    var event: Event
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    
    init(event: Event){
        self.event = event
        viewModel.getRecord(event: event)
    }
    
    var body: some View {
        SimpleNavigationView(title: event.id) {
            VStack(spacing: 10) {
                Picker("period", selection: self.$periodScale, content: {
                    Text("1日毎").tag(0)
                    Text("3日平均").tag(1)
                    Text("9日平均").tag(2)
                    Text("27日平均").tag(3)
                })
                .pickerStyle(SegmentedPickerStyle())
                HStack(spacing: 0) {
                    VStack(spacing:0) {
                        ForEach(weightScale, id: \.self) { index in
                            Text(String(format: "%.0f", viewModel.maxWeight * index))
                                .foregroundColor(viewModel.getThemeColor())
                                .font(.footnote)
                            Spacer()
                        }
                        Text("0")
                            .foregroundColor(viewModel.getThemeColor())
                            .font(.footnote)
                    }
                    .offset(y: 8)
                    .frame(minWidth: 15, minHeight: 0, maxHeight: .infinity)
                    .padding(.bottom, 63)
                    .padding(.trailing, 10)
                    .padding(.top, 22)
                    Rectangle()
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 3)
                        .padding(.bottom, 30)
                    if periodScale == 0 {
                        ScrollViewReader{ proxy in
                            ScrollView(.horizontal){
                                HStack(alignment: .bottom, spacing: 0) {
                                    ForEach(viewModel.records) { record in
                                        VStack(spacing: 0){
                                            GeometryReader { geometry in
                                                VStack(spacing: 0) {
                                                    Rectangle()
                                                        .frame(minHeight: 0, maxHeight: .infinity)
                                                        .opacity(0)
                                                    Rectangle()
                                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/viewModel.maxWeight))
                                                        .foregroundColor(viewModel.getThemeColor())
                                                }
                                            }.opacity(record.dummy ? 0.5 : 1)
                                            Text(record.dummy ? "" : "\(record.rep)")
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                                .padding(.bottom, 5)
                                                .background(viewModel.getThemeColor())
                                                .opacity(record.dummy ? 0.5 : 1)
                                            Rectangle()
                                                .frame(width: 40, height: 3)
                                                .foregroundColor(viewModel.getThemeColor())
                                            Text(dateFormatter.string(from: record.date))
                                                .frame(width: 34)
                                                .foregroundColor(viewModel.getThemeColor())
                                                .font(.footnote)
                                                .padding(.bottom, 10)
                                                .padding(.top, 4)
                                                .id(record.id)
                                        }
                                    }
                                    .padding(.top, 38)
                                    .onAppear{
                                        proxy.scrollTo(viewModel.latestID)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                            }
                        }

                    } else if periodScale == 1 {
                        ScrollViewReader{ proxy in
                            ScrollView(.horizontal){
                                HStack(alignment: .bottom, spacing: 0) {
                                    ForEach(viewModel.records3) { record in
                                        VStack(spacing: 0){
                                            GeometryReader { geometry in
                                                VStack(spacing: 0) {
                                                    Rectangle()
                                                        .frame(minHeight: 0, maxHeight: .infinity)
                                                        .opacity(0)
                                                    Rectangle()
                                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/viewModel.maxWeight))
                                                        .foregroundColor(viewModel.getThemeColor())
                                                }
                                            }.opacity(record.dummy ? 0.5 : 1)
                                            Text(record.dummy ? "" : "\(record.rep)")
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                                .padding(.bottom, 5)
                                                .background(viewModel.getThemeColor())
                                                .opacity(record.dummy ? 0.5 : 1)
                                            Rectangle()
                                                .frame(width: 40, height: 3)
                                                .foregroundColor(viewModel.getThemeColor())
                                            Text(dateFormatter.string(from: record.date))
                                                .frame(width: 34)
                                                .foregroundColor(viewModel.getThemeColor())
                                                .font(.footnote)
                                                .padding(.bottom, 10)
                                                .padding(.top, 4)
                                                .id(record.id)
                                        }
                                    }
                                    .padding(.top, 38)
                                    .onAppear{
                                        proxy.scrollTo(viewModel.latestID3)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                            }
                        }

                    } else if periodScale == 2 {
                        ScrollViewReader{ proxy in
                            ScrollView(.horizontal){
                                HStack(alignment: .bottom, spacing: 0) {
                                    ForEach(viewModel.records9) { record in
                                        VStack(spacing: 0){
                                            GeometryReader { geometry in
                                                VStack(spacing: 0) {
                                                    Rectangle()
                                                        .frame(minHeight: 0, maxHeight: .infinity)
                                                        .opacity(0)
                                                    Rectangle()
                                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/viewModel.maxWeight))
                                                        .foregroundColor(viewModel.getThemeColor())
                                                }
                                            }.opacity(record.dummy ? 0.5 : 1)
                                            Text(record.dummy ? "" : "\(record.rep)")
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                                .padding(.bottom, 5)
                                                .background(viewModel.getThemeColor())
                                                .opacity(record.dummy ? 0.5 : 1)
                                            Rectangle()
                                                .frame(width: 40, height: 3)
                                                .foregroundColor(viewModel.getThemeColor())
                                            Text(dateFormatter.string(from: record.date))
                                                .frame(width: 34)
                                                .foregroundColor(viewModel.getThemeColor())
                                                .font(.footnote)
                                                .padding(.bottom, 10)
                                                .padding(.top, 4)
                                                .id(record.id)
                                        }
                                    }
                                    .padding(.top, 38)
                                    .onAppear{
                                        proxy.scrollTo(viewModel.latestID9)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                            }
                        }
                    } else {
                        ScrollViewReader{ proxy in
                            ScrollView(.horizontal){
                                HStack(alignment: .bottom, spacing: 0) {
                                    ForEach(viewModel.records27) { record in
                                        VStack(spacing: 0){
                                            GeometryReader { geometry in
                                                VStack(spacing: 0) {
                                                    Rectangle()
                                                        .frame(minHeight: 0, maxHeight: .infinity)
                                                        .opacity(0)
                                                    Rectangle()
                                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/viewModel.maxWeight))
                                                        .foregroundColor(viewModel.getThemeColor())
                                                }
                                            }.opacity(record.dummy ? 0.5 : 1)
                                            Text(record.dummy ? "" : "\(record.rep)")
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                                .padding(.bottom, 5)
                                                .background(viewModel.getThemeColor())
                                                .opacity(record.dummy ? 0.5 : 1)
                                            Rectangle()
                                                .frame(width: 40, height: 3)
                                                .foregroundColor(viewModel.getThemeColor())
                                            Text(dateFormatter.string(from: record.date))
                                                .frame(width: 34)
                                                .foregroundColor(viewModel.getThemeColor())
                                                .font(.footnote)
                                                .padding(.bottom, 10)
                                                .padding(.top, 4)
                                                .id(record.id)
                                        }
                                    }
                                    .padding(.top, 38)
                                    .onAppear{
                                        proxy.scrollTo(viewModel.latestID27)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                            }
                        }

                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding(10)
        }
    }
}
