//
//  ProImageView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct ProImageView: View {
    @ObservedObject var viewModel = ViewModel()
    var image: String
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(viewModel.getThemeColor(), lineWidth: 3))
    }
}
