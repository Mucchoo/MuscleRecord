//
//  TutorialArrowView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialArrowView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        Image(systemName: "arrow.down.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(viewModel.getThemeColor())
    }
}
