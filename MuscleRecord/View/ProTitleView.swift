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
                    if isImage {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(viewModel.getThemeColor())
                            .frame(width: 30, height: 30)
                        Image(icon)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(viewModel.getThemeColor())
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
