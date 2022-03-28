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
                ForEach(0..<10) { num in
                    CardView()
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                    Spacer()
                }
            }
            .padding(.top, 10)
        }
    }

}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
