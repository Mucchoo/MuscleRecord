//
//  TutorialTextView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialTextView: View {
    @ObservedObject private var viewModel = ViewModel()
    var text: String
    //チュートリアルの説明文
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .foregroundColor(.black)
    }
}
