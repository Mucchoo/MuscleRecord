//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var purchaseViewModel = PurchaseViewModel()
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var isShowingAlert = false
    @State private var isShowingPro = false
    @State private var isPro = false
    @State var isActive = false
    @State var isShowingTutorial = false

    init(){
        //ナビゲーションバーのUI調整
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(viewModel.getThemeColor())
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
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
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(firebaseViewModel.events) { event in
                        //種目
                        VStack {
                            HStack(alignment: .top) {
                                //編集ボタン
                                NavigationLink(destination: EditView(event: event)){
                                    Image(systemName: R.string.localizable.editIcon())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(viewModel.getThemeColor())
                                }
                                //種目名
                                Text(event.name)
                                    .fontWeight(.bold)
                                    .lineLimit(2)
                                    .foregroundColor(Color(R.color.fontColor()!))
                                Spacer()
                                //記録ボタン（記録後は表示を変更）
                                NavigationLink(destination: RecordView(event: event)){
                                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                                        Image(systemName: R.string.localizable.pencilIcon())
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(viewModel.getThemeColor())
                                    } else {
                                        Image(systemName: R.string.localizable.pencilIconFill())
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
                                    Text(R.string.localizable.weightIs() + String(format: "%.1f", event.latestWeight) + R.string.localizable.kg())
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(R.color.fontColor()!))
                                    Text(R.string.localizable.repIs() + String(event.latestRep) + R.string.localizable.rep())
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(R.color.fontColor()!))
                                }
                                Spacer()
                                //グラフを見るボタン
                                NavigationLink(destination: GraphView(event: event)) {
                                    Text(R.string.localizable.seeGraph())
                                        .foregroundColor(viewModel.getThemeColor())
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .frame(maxHeight: 110)
                        .padding(20)
                        .background(Color(R.color.cellColor()!))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                    //6個以上種目を登録する場合アラートを表示し内課金購入ページに遷移
                    NavigationLink(destination: ProView(shouldPopToRootView: $isShowingPro), isActive: $isShowingPro) {
                        EmptyView()
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    firebaseViewModel.getEvent()
                }
            }
            .background(Color(R.color.backgroundColor()!))
            .navigationBarTitle(R.string.localizable.homeViewTitle(), displayMode: .inline)
            .toolbar {
                //設定ボタン
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingView(rootIsActive: $isActive), isActive: $isActive){
                        Image(systemName: R.string.localizable.settingIcon()).foregroundColor(.white)
                    }
                }
                //種目追加ボタン
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    //6個以上種目を登録する場合アラートを表示し内課金購入ページに遷移
                    if firebaseViewModel.events.count > 4 {
                        if purchaseViewModel.isPurchased() {
                            NavigationLink(destination: AddView()){
                                Image(systemName: R.string.localizable.plusIcon()).foregroundColor(.white)
                            }
                        } else {
                            Button( action: {
                                isShowingAlert = true
                            }, label: {
                                Image(systemName: R.string.localizable.plusIcon()).foregroundColor(.white)
                            })
                        }
                    } else {
                        NavigationLink(destination: AddView()){
                            Image(systemName: R.string.localizable.plusIcon()).foregroundColor(.white)
                        }
                    }
                }
            }
            //ログインしていない場合チュートリアルを表示
            .onAppear {
                if !firebaseViewModel.isLoggedIn() {
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
                return Alert(title: Text(R.string.localizable.onlyFiveEventsAvailableInFree()), message: Text(R.string.localizable.eventsWillBeUnlimitedIfJoinPro()), primaryButton: .default(Text(R.string.localizable.close())), secondaryButton: .default(Text(R.string.localizable.seePro()), action: {
                    isShowingPro = true
                }))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
