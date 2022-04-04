//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/24.
//

import SwiftUI
import Firebase

struct ListView: View {
    @ObservedObject var model = ViewModel()
    init() {
        model.getData("user")
    }

    var body: some View {
//        List (model.events) { event in
//            Text(event.id)
//            Text(event.name)
//            Text(String(event.latestWeight))
//            Text(String(event.latestRep))
//        }
        
        ScrollView {
            VStack(spacing: 0) {
                ForEach(model.events) { event in
                    VStack {
                        HStack(alignment: .top) {
                            Text(event.name)
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
                                    Text("重量：\(event.latestWeight)kg ")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("FontColor"))
                                    Text("↑")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("AccentColor"))
                                }
                                HStack(spacing: 10) {
                                    Text("回数：\(event.latestRep)rep")
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
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                    Spacer()
                }
            }
            .padding(.top, 10)
        }
    }

}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
