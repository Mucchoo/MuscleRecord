//
//  TutorialArrowView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialArrowView: View {
    @ObservedObject var viewModel = ViewModel()
    //チュートリアルの下向きの矢印
    var body: some View {
        Image(systemName: "arrow.down.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(viewModel.getThemeColor())
    }
}
