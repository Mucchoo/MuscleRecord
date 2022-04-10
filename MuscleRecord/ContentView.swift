//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModel()
    @State private var date = Date()
    @State private var showingDataPicker = false
    init(){
        UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        appearance.backgroundColor = UIColor(model.getThemeColor())
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(model.getThemeColor())
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(model.getThemeColor()),], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white,], for: .selected)
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(model.events) { event in
                        VStack {
                            HStack(alignment: .top) {
                                NavigationLink(destination: EditView(event: event)){
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(model.getThemeColor())
                                }
                                Text(event.name)
                                    .fontWeight(.bold)
                                    .lineLimit(2)
                                    .foregroundColor(Color("FontColor"))
                                Spacer()
                                NavigationLink(destination: RecordView(event: event)){
                                    if model.dateFormat(date: Date()) == model.dateFormat(date: event.latestDate) {
                                        Image(systemName: "pencil.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(model.getThemeColor())
                                    } else {
                                        Image(systemName: "pencil.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(model.getThemeColor())
                                    }
                                }
                            }.frame(minHeight: 43)
                            Spacer()
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("重量：\(String(format: "%.1f", event.latestWeight))kg ")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("FontColor"))
                                    Text("回数：\(event.latestRep)rep")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("FontColor"))
                                }
                                Spacer()
                                NavigationLink(destination: GraphView(event: event)) {
                                    Text("グラフを見る ▶︎")
                                        .foregroundColor(model.getThemeColor())
                                        .fontWeight(.semibold)
                                }
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
                print("onAppearが呼び出されました")
                model.getEvent()
            }
                .background(Color("BackgroundColor"))
                .navigationBarTitle("Muscle Record", displayMode: .inline)
                .navigationBarItems(
                    leading: NavigationLink(destination: SettingView()){
                        Image(systemName: "line.3.horizontal").foregroundColor(.white)
                    },
                    trailing: NavigationLink(destination: AddView()){
                        Image(systemName: "plus").foregroundColor(.white)
                    }
                )
        }
    }
}
