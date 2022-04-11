//
//  ThemeColorView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/10.
//

import SwiftUI

struct ThemeColorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = ViewModel()
    @State var colorChanged = false
    let itemWidth = (UIScreen.main.bounds.width - 40)/3
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        if colorChanged {
            ContentView()
        } else {
            VStack(){
                ZStack(){
                    HStack(){
                        Button(
                            action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .frame(width: 20, height: 15)
                            }
                        )
                        .tint(.white)
                        .padding(.leading, 20)
                        Spacer()
                    }
                    Text("テーマカラー")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 10)
                .background(model.getThemeColor())
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<6) { num in
                        Button(action: {
                            UserDefaults.standard.set(num, forKey: "themeColorNumber")
                            colorChanged = true
                        }) {
                            RoundedRectangle(cornerRadius: 20).foregroundColor(Color("ThemeColor\(num)"))
                        }.frame(width: itemWidth, height: itemWidth)
                    }
                }
                .padding(.horizontal, 10)
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
