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
    var body: some View {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(viewModel.getThemeColor())
                        .frame(width: 30, height: 30)
                    if isImage {
                        Image(icon)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: icon)
                            .frame(width: 10)
                            .padding(.bottom, 2)
                            .foregroundColor(.white)
                    }
                }
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.fontColor)
                    Spacer()
                }
            }
    }
}
