//
//  TutorialView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ViewModel()
    var body: some View {
        TabView(){
            ScrollView(){
                VStack(){
                    Image("Tutorial1")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(viewModel.themeColor)
                    Image("Tutorial2")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(viewModel.themeColor)
                    Image("Tutorial3")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Text("①「＋」ボタンを押し、②名前を入力して③種目を追加します。")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            }
            ScrollView(){
                VStack(){
                    Image("Tutorial4")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(viewModel.themeColor)
                    Image("Tutorial5")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(viewModel.themeColor)
                    Image("Tutorial6")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Text("①ボタンを押し、②使った重量と動作の回数を入力して③記録します。④に最新の記録が表示されます。")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            }
            ScrollView(){
                VStack(){
                    Image("Tutorial7")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(viewModel.themeColor)
                    Image("Tutorial8")
                        .resizable()
                        .scaledToFit()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.themeColor, lineWidth: 3))
                    Text("①「グラフを見る」を押すと、それまでの記録がグラフで確認できます。②未記入日は半透明で表示され、棒の長さは重量、回数は③に表示されます。")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            }
            ScrollView(){
                VStack(){
                    Image("Tutorial9")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(viewModel.themeColor)
                    Text("記録を続けて筋肉の成長をデータ化しましょう！")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Button( action: {
                        dismiss()
                    }, label: {
                        Text("始める")
                            .fontWeight(.bold)
                            .frame(width: 300, height: 70, alignment: .center)
                            .background(viewModel.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.top, 30)
                    })
                }
                .padding(40)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle("使い方")
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
