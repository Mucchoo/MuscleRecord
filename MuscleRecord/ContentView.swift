//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct ContentView: View {

    init(){
        UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(Color("AccentColor"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            TabView{
                ListView()
                    .tabItem{
                        Image(systemName: "list.dash")
                        Text("リスト")
                    }
                GraphView()
                    .tabItem{
                        Image(systemName: "chart.bar.fill")
                        Text("グラフ")
                    }
                SettingView()
                    .tabItem{
                        Image(systemName: "gearshape.fill")
                        Text("設定")
                    }
            }
            .navigationBarTitle(Text("種目リスト"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {print("eee")}) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.white)
                },
                trailing: Button(action: {
                    print("ff")
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
