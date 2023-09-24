//
//  GraphView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct GraphView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    private var weightScale: [Float] = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0]
    var event: Event
    //選択した種目のデータをグラフに表示
    init(event: Event){
        self.event = event
        firebaseViewModel.getRecord(event: event)
    }
    
    var body: some View {
        SimpleNavigationView(title: event.name) {
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    //グラフのメモリを種目の最大重量から生成
                    VStack(spacing:0) {
                        ForEach(weightScale, id: \.self) { index in
                            Text(String(format: "%.0f", firebaseViewModel.maxWeight * index))
                                .foregroundColor(viewModel.getThemeColor())
                                .font(.footnote)
                            Spacer()
                        }
                    }
                    .offset(y: 8)
                    .frame(minWidth: 15, minHeight: 0, maxHeight: .infinity)
                    .padding(.bottom, 22)
                    .padding(.trailing, 10)
                    .padding(.top, 22)
                    //メモリとグラフを仕切る線
                    Rectangle()
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 3)
                        .padding(.bottom, 30)
                    
                    GraphBodyView(records: firebaseViewModel.records, latestID: firebaseViewModel.latestRecord, maxWeight: firebaseViewModel.maxWeight)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }.padding(10)
        }
    }
}
