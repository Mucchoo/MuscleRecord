//
//  ThemeColorView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/10.
//

import SwiftUI

struct ThemeColorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @State var colorChanged = false
    var body: some View {
        if colorChanged {
            MuscleRecordView()
        } else {
            VStack(spacing: 0){
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
                .background(viewModel.getThemeColor())
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0..<3) { i in
                            Button(action: {
                                UserDefaults.standard.set(i, forKey: "themeColorNumber")
                                colorChanged = true
                            }) {
                                Rectangle()
                                    .foregroundColor(Color("ThemeColor\(i)"))
                            }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(3..<6) { i in
                            Button(action: {
                                UserDefaults.standard.set(i, forKey: "themeColorNumber")
                                colorChanged = true
                            }) {
                                Rectangle()
                                    .foregroundColor(Color("ThemeColor\(i)"))
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
