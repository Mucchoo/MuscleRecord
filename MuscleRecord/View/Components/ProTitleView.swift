//
//  ProTitleView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct ProTitleView: View {
    @ObservedObject var viewModel = ViewModel()
    var icon: String
    var title: String
    var isImage: Bool
    //内課金ページのタイトル
    var body: some View {
            HStack {
                //アイコン
                ZStack {
                    //画像かSFSymbolsで表示方法を変更
                    if isImage {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(viewModel.getThemeColor())
                            .frame(width: 30, height: 30)
                        Image(icon)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(viewModel.getThemeColor())
                    }
                }
                //タイトル
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(R.color.fontColor()!))
                    Spacer()
                }
            }.padding(.top, 10)
    }
}
