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
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(viewModel.getThemeColor())
                                }
                                //種目名
                                Text(event.name)
                                    .fontWeight(.bold)
                                    .lineLimit(2)
                                    .foregroundColor(viewModel.fontColor)
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
                                    Text("重量：\(String(format: "%.1f", event.latestWeight))kg ")
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.fontColor)
                                    Text("回数：\(event.latestRep)rep")
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.fontColor)
                                }
                                Spacer()
                                //グラフを見るボタン
                                NavigationLink(destination: GraphView(event: event)) {
                                    Text("グラフを見る ▶︎")
                                        .foregroundColor(viewModel.getThemeColor())
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .frame(maxHeight: 110)
                        .padding(20)
                        .background(viewModel.cellColor)
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
            .background(Color("BackgroundColor"))
            .navigationBarTitle("筋トレ記録", displayMode: .inline)
            .toolbar {
                //設定ボタン
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingView(rootIsActive: $isActive), isActive: $isActive){
                        Image(systemName: "line.3.horizontal").foregroundColor(.white)
                    }
                }
                //種目追加ボタン
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    //6個以上種目を登録する場合アラートを表示し内課金購入ページに遷移
                    if firebaseViewModel.events.count > 4 {
                        if purchaseViewModel.isPurchased() {
                            NavigationLink(destination: AddView()){
                                Image(systemName: "plus").foregroundColor(.white)
                            }
                        } else {
                            Button( action: {
                                isShowingAlert = true
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
                return Alert(title: Text("無料版で追加できる種目は5個です"), message: Text("Proにをアンロックすれば、無制限に追加することができます。"), primaryButton: .default(Text("閉じる")), secondaryButton: .default(Text("Proを見る"), action: {
                    isShowingPro = true
                }))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
