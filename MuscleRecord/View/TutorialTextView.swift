//
//  TutorialTextView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialTextView: View {
    @ObservedObject var viewModel = ViewModel()
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .foregroundColor(viewModel.fontColor)
    }
}
