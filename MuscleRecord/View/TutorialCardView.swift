//
//  TutorialCardView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/18.
//

import SwiftUI

struct TutorialCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        VStack(){
            Spacer()
            content
            Spacer()
        }
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}
