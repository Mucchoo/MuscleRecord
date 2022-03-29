//
//  CardView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("ここに種目名が入ります")
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(Color("FontColor"))
                Spacer()
                NavigationLink(destination: InputView()){
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("AccentColor"))
                }
            }.frame(minHeight: 43)
            Spacer()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 10) {
                        Text("重量：60kg ")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("FontColor"))
                        Text("↑")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("AccentColor"))
                    }
                    HStack(spacing: 10) {
                        Text("回数：10rep")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("FontColor"))
                        Text("↓")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                Spacer()
                Text("グラフを見る ▶︎")
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.semibold)
            }
        }
        .frame(maxHeight: 110)
        .padding(20)
        .cornerRadius(20)
        .background(Color("CellColor"))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .previewLayout(.sizeThatFits)
    }
}
