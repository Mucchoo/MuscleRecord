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
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(model.events) { event in
                    VStack {
                        HStack(alignment: .top) {
                            NavigationLink(destination: EditView(editingEvent: event)){
                                Image(systemName: "ellipsis.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("AccentColor"))
                            }
                            Text(event.name)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(Color("FontColor"))
                            Spacer()
                            NavigationLink(destination: RecordView(recordingEvent: event)){
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("AccentColor"))
                            }
                        }.frame(minHeight: 43)
                        Spacer()
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("重量：\(event.latestWeight)kg ")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("FontColor"))
                                Text("回数：\(event.latestRep)rep")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("FontColor"))
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
        }.onAppear {
            model.getEvent()
        }
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
