//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var purchaseViewModel = PurchaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var isShowingAlert = false
    @State private var isShowingPro = false
    @State private var isPro = false
    @State var isShowingTutorial = false

    init(){
        //グラフの表示幅選択ボタンのUI調整
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(viewModel.getThemeColor())
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(viewModel.getThemeColor())], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white,], for: .selected)
        //チュートリアルのPageControlのUI調整
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(viewModel.getThemeColor())
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        //20回起動毎にレビューアラートを表示
        viewModel.showReviewForEvery20Launchs()
    }
    
    var body: some View {
        ScrollView {
            header
            events
                .onAppear {
                    firebaseViewModel.getEvent()
                }
            //6個以上種目を登録する場合アラートを表示し内課金購入ページに遷移
            NavigationLink(destination: ProView(), isActive: $isShowingPro) {
                EmptyView()
            }
        }
        .background(Color("BackgroundColor"))
        .toolbar(.hidden)
        //ログインしていない場合チュートリアルを表示
        .onAppear {
            if !firebaseViewModel.isLoggedIn {
                isShowingTutorial = true
            }
        }
        //チュートリアル
        .fullScreenCover(isPresented: $isShowingTutorial, onDismiss: {
            firebaseViewModel.getEvent()
        }) {
            TutorialView(isShowingTutorial: $isShowingTutorial)
        }
        //非課金状態で6個以上種目を登録する場合アラートを表示
        .alert(isPresented: $isShowingAlert) {
            return Alert(title: Text("onlyFiveEventsAvailableInFree"), message: Text("eventsWillBeUnlimitedIfJoinPro"), primaryButton: .default(Text("close")), secondaryButton: .default(Text("seePro"), action: {
                isShowingPro = true
            }))
        }
    }
    
    private var header: some View {
        HStack {
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "hexagon.fill")
                    .foregroundColor(.gray)
                    .overlay(content: {
                        Circle()
                            .stroke(.white,lineWidth: 2)
                            .padding(7)
                    })
                    .frame(width: 40, height: 40)
                    .background(Color.white,in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            }
            .addSpotlight(0, shape: .rounded, roundedRadius: 10, text: "Expenses Filtering")
            
            Spacer()
            Text("Record List")
                .font(.title2)
                .bold()
            Spacer()
            
            if firebaseViewModel.events.count > 4 {
                if UserDefaults.standard.bool(forKey: "purchaseStatus") {
                    NavigationLink(destination: AddView()){
                        addButtonLabel
                    }
                } else {
                    Button( action: {
                        isShowingAlert = true
                    }, label: {
                        addButtonLabel
                    })
                }
            } else {
                NavigationLink(destination: AddView()){
                    addButtonLabel
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var addButtonLabel: some View {
        Image(systemName: "plus")
            .bold()
            .foregroundColor(.gray)
            .overlay(content: {
                Circle()
                    .stroke(.white,lineWidth: 2)
                    .padding(7)
            })
            .frame(width: 40, height: 40)
            .background(Color.white,in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
    }
    
    private var events: some View {
        VStack(spacing: 0) {
            ForEach(firebaseViewModel.events) { event in
                eventView(event)
                Spacer()
            }
        }
        .padding(.top, 10)
    }
    
    private func eventView(_ event: Event) -> some View {
        VStack {
            HStack(alignment: .top) {
                //編集ボタン
                NavigationLink(destination: EditView(event: event)){
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.getThemeColor())
                }
                //種目名
                Text(event.name)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(Color("FontColor"))
                Spacer()
                //記録ボタン（記録後は表示を変更）
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
                //最新の重量と回数
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "weightIs") + String(format: "%.1f", event.latestWeight) + "kg")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("FontColor"))
                    Text(String(localized: "repIs") + String(event.latestRep) + "rep")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("FontColor"))
                }
                Spacer()
                //グラフを見るボタン
                NavigationLink(destination: GraphView(event: event)) {
                    Text("seeGraph")
                        .foregroundColor(viewModel.getThemeColor())
                        .fontWeight(.semibold)
                }
            }
        }
        .frame(maxHeight: 110)
        .padding(20)
        .background(Color("CellColor"))
        .cornerRadius(20)
        .shadow(color: Color("FontColor").opacity(0.5), radius: 4, x: 0, y: 2)
        .padding(.top, 5)
        .padding(.horizontal, 10)
    }
}
