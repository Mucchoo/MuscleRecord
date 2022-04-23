//
//  GraphBarView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct GraphBodyView: View {
    @ObservedObject var viewModel = ViewModel()
    var records: [Record]
    var latestID: String
    var maxWeight: Float
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    
    var body: some View {
        ScrollViewReader{ proxy in
            ScrollView(.horizontal){
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(records) { record in
                        VStack(spacing: 0){
                            GeometryReader { geometry in
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                        .opacity(0)
                                    Rectangle()
                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/maxWeight))
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
                                .frame(width: 36)
                                .foregroundColor(viewModel.getThemeColor())
                                .font(.footnote)
                                .padding(.bottom, 10)
                                .padding(.top, 4)
                                .id(record.id)
                        }
                    }
                    .padding(.top, 38)
                    .onAppear{
                        proxy.scrollTo(latestID)
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
