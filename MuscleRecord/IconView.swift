//
//  IconView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct IconView: View {
    @Environment(\.dismiss) var dismiss
    let itemWidth = (UIScreen.main.bounds.width - 40)/3
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State var viewModel = ViewModel()
    var body: some View {
        ScrollView(){
            LazyVGrid(columns: columns, spacing: 10) {
                Button(action: {
                    UIApplication.shared.setAlternateIconName(nil)
                    dismiss()
                }) {
                    Image("Icon")
                        .resizable()
                        .cornerRadius(20)
                }.frame(width: itemWidth, height: itemWidth)
                ForEach(0..<20) { num in
                    Button(action: {
                        UIApplication.shared.setAlternateIconName("AppIcon\(num)")
                        dismiss()
                    }) {
                        Image("Icon\(num)")
                            .resizable()
                            .cornerRadius(20)
                    }.frame(width: itemWidth, height: itemWidth)
                }
            }
            .padding(10)
        }
            .navigationTitle("アイコン")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                        }
                    ).tint(.white)
                }
            }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
