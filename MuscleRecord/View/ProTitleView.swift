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
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 100).foregroundColor(viewModel.getThemeColor())
            HStack(){
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(.white)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.padding(5)
        }
    }
}
