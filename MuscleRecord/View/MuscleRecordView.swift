//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI
import Firebase

struct MuscleRecordView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var date = Date()
    @State var showTutorial = false
    
    init(){
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(viewModel.getThemeColor())
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(viewModel.getThemeColor())
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(viewModel.getThemeColor())], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white,], for: .selected)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(viewModel.getThemeColor())
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.events) { event in
                        VStack {
                            HStack(alignment: .top) {
                                NavigationLink(destination: EditView(event: event)){
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(viewModel.getThemeColor())
                                }
                                Text(event.name)
                                    .fontWeight(.bold)
                                    .lineLimit(2)
                                    .foregroundColor(viewModel.fontColor)
                                Spacer()
                                NavigationLink(destination: RecordView(event: event)){
                                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                                        Image(systemName: "pencil.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(viewModel.getThemeColor())
                                    } else {
                                        Image(systemName: "pencil.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(viewModel.getThemeColor())
                                    }
                                }
                            }.frame(minHeight: 43)
                            Spacer()
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("重量：\(String(format: "%.1f", event.latestWeight))kg ")
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.fontColor)
                                    Text("回数：\(event.latestRep)rep")
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.fontColor)
                                }
                                Spacer()
                                NavigationLink(destination: GraphView(event: event)) {
                                    Text("グラフを見る ▶︎")
                                        .foregroundColor(viewModel.getThemeColor())
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .frame(maxHeight: 110)
                        .padding(20)
                        .cornerRadius(20)
                        .background(viewModel.cellColor)
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    viewModel.getEvent()
                }
            }
            .background(Color("BackgroundColor"))
            .navigationBarTitle("筋トレ記録", displayMode: .inline)
            .navigationBarItems(
                leading: NavigationLink(destination: SettingView()){
                    Image(systemName: "line.3.horizontal").foregroundColor(.white)
                },
                trailing: NavigationLink(destination: AddView()){
                    Image(systemName: "plus").foregroundColor(.white)
                }
            )
            .onAppear {
                if Auth.auth().currentUser == nil {
                    showTutorial = true
                }
            }
            .fullScreenCover(isPresented: $showTutorial, onDismiss: {
                viewModel.getEvent()
            }) {
                TutorialView(showTutorial: $showTutorial)
            }
        }
    }
}
