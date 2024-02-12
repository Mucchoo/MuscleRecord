//
//  TutorialCardView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialCardView<Content: View>: View {
    @ObservedObject private var viewModel = ViewModel()
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    //チュートリアルのカード
    var body: some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
        .background(Color("ClearColor"))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}
