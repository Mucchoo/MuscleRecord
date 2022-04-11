//
//  SettingView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = FirebaseModel()
    @State var viewModel = ViewModel()
    @State private var isActive = false
    @Binding var isFirstViewActive: Bool
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Pro")){
//                    FormRowView(icon: "gift", firstText: "Proにアップグレード", secondText: "")
                    NavigationLink(destination: ThemeColorView()) {
                        FormRowView(icon: "paintbrush.pointed.fill", firstText: "テーマカラー", secondText: "")
                    }
                    NavigationLink(destination: DarkModeView(isFirstViewActive: $isFirstViewActive), isActive: $isActive) {
                        Button(action: {
                            self.isActive = true
                        }) {
                            FormRowView(icon: "circle.righthalf.filled", firstText: "ダークモード", secondText: viewModel.appearanceName)
                        }
                    }
                    NavigationLink(destination: DarkModeView2()) {
                        FormRowView(icon: "circle.righthalf.filled", firstText: "ダークモード", secondText: viewModel.appearanceName)
                    }
//                    HStack{
//                        Image("OrangeIcon")
//                            .resizable()
//                            .frame(width: 36, height: 36)
//                            .cornerRadius(8)
//                        Text("アイコン").foregroundColor(Color("FontColor"))
//                        Spacer()
//                    }
                }
                Section(footer: Text("©︎ 2022 Musa Yazuju")){
//                    FormRowView(icon: "questionmark", firstText: "使い方", secondText: "")
//                    FormRowView(icon: "person", firstText: "アカウント作成", secondText: "")
//                    FormRowView(icon: "star", firstText: "レビューで応援！", secondText: "")
//                    FormRowView(icon: "square.and.arrow.up", firstText: "アプリをシェア", secondText: "")
//                    FormRowView(icon: "envelope", firstText: "ご意見・ご要望", secondText: "")
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("設定")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                    }
                ).tint(.white)
            }
        }
    }
}
