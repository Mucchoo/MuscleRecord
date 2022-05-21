//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI
import Firebase
import StoreKit

struct MuscleRecordView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var date = Date()
    @State private var showAlert = false
    @State private var showPro = false
    @State private var isPro = false
    @State var showTutorial = false
    @State var isActive : Bool = false
    
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
        if UserDefaults.standard.integer(forKey: "LaunchedTimes") > 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                UserDefaults.standard.set(0, forKey: "LaunchedTimes")
            }
        }
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
                    NavigationLink(destination: ProView(shouldPopToRootView: $showPro), isActive: $showPro) {
                        EmptyView()
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    viewModel.getEvent()
                }
            }
            .background(Color("BackgroundColor"))
            .navigationBarTitle("筋トレ記録", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingView(rootIsActive: $isActive), isActive: $isActive){
                        Image(systemName: "line.3.horizontal").foregroundColor(.white)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.events.count > 4 {
                        if viewModel.customerInfo() {
                            NavigationLink(destination: AddView()){
                                Image(systemName: "plus").foregroundColor(.white)
                            }
                        } else {
                            Button( action: {
                                showAlert = true
                            }, label: {
                                Image(systemName: "plus").foregroundColor(.white)
                            })
                        }
                    } else {
                        NavigationLink(destination: AddView()){
                            Image(systemName: "plus").foregroundColor(.white)
                        }
                    }
                }
            }
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
            .alert(isPresented: $showAlert) {
                return Alert(title: Text("無料版で追加できる種目は5個です"), message: Text("Proにをアンロックすれば、無制限に追加することができます。"), primaryButton: .default(Text("閉じる")), secondaryButton: .default(Text("Proを見る"), action: {
                    showPro = true
                }))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
