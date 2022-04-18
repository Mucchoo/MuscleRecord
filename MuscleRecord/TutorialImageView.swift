//
//  TutorialImageView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialImageView: View {
    @ObservedObject var viewModel = ViewModel()
    var image: String
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 20)
    }
}
