//
//  ProImageView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/16.
//

import SwiftUI

struct ProImageView: View {
    var image: String
    //内課金ページの画像
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .cornerRadius(20)
    }
}
