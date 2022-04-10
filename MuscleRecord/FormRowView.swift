//
//  FormRowView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct FormRowView: View {
    @ObservedObject var model = ViewModel()
    var icon: String
    var firstText: String
    var secondText: String
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(model.getThemeColor())
                Image(systemName: icon)
                    .foregroundColor(Color.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            Text(firstText).foregroundColor(Color("FontColor"))
            Spacer()
            Text(secondText).foregroundColor(Color.gray)
        }
    }
}
