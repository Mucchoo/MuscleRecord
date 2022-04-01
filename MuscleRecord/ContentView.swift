//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var date = Date()
    @State private var showingDataPicker = false
    init(){
        UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(Color("AccentColor"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("AccentColor"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("AccentColor")),], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white,], for: .selected)
    }
    
    var body: some View {
        TabView{
            NavigationView{
                ListView()
                    .background(Color("BackgroundColor"))
                    .navigationBarTitle(Text("2022年 3月1日"), displayMode: .inline)
                    .navigationBarItems(
                        trailing: NavigationLink(destination: AddView()){
                            Image(systemName: "plus").foregroundColor(.white)
                        }
                    )
            }
            .tabItem{
                Image(systemName: "list.dash")
                Text("リスト")
            }
            NavigationView{
                GraphView()
                    .navigationBarTitle(Text("グラフ"), displayMode: .inline)
            }
            .tabItem{
                Image(systemName: "chart.bar.fill")
                Text("グラフ")
            }
            NavigationView{
                SettingView()
                    .navigationBarTitle(Text("設定"), displayMode: .inline)
            }.background(Color("BackgroundColor"))
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("設定")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
