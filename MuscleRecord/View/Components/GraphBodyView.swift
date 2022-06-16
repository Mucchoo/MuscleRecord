//
//  GraphBarView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct GraphBodyView: View {
    @ObservedObject private var viewModel = ViewModel()
    var records: [Record]
    var latestID: String
    var maxWeight: Float
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    //グラフの本体
    var body: some View {
        //初期状態ではグラフの1番左（1番古い情報）が表示されるので自動で1番右までスクロール
        ScrollViewReader{ proxy in
            ScrollView(.horizontal){
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(records) { record in
                        //グラフの棒
                        VStack(spacing: 0){
                            GeometryReader { geometry in
                                VStack(spacing: 0) {
                                    //棒上部の空白
                                    Rectangle()
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                        .opacity(0)
                                    //棒本体を種目の最大重量から長さを計算して生成
                                    Rectangle()
                                        .frame(width: 30, height: geometry.size.height * CGFloat(record.weight/maxWeight))
                                        .foregroundColor(viewModel.getThemeColor())
                                }
                            //未記録日のダミーは半透明で表示
                            }.opacity(record.dummy ? 0.5 : 1)
                            //レップ数（未記録日は表示しない）
                            Text(record.dummy ? "" : "\(record.rep)")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(.bottom, 5)
                                .background(viewModel.getThemeColor())
                                .opacity(record.dummy ? 0.5 : 1)
                            //グラフの下の横棒
                            Rectangle()
                                .frame(width: 40, height: 3)
                                .foregroundColor(viewModel.getThemeColor())
                            //グラフ記録日
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
                    //初期状態ではグラフの1番左（1番古い情報）が表示されるので自動で1番右までスクロール
                    .onAppear{
                        proxy.scrollTo(latestID)
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
