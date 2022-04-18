//
//  ProTextView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct ProTextView: View {
    @ObservedObject var viewModel = ViewModel()
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(viewModel.fontColor)
    }
}
