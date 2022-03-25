//
//  ContentView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/24.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("2022年 3月1日")
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top, 10)
                ForEach(0..<10) { num in
                    CardView()
                        .cornerRadius(20)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    Spacer()
                }
            }.background(Color("BackgroundColor"))
        }
    }

}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
