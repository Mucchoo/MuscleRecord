//
//  ThemeColorView2.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/11.
//

import SwiftUI

struct DarkModeView2: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = FirebaseModel()
    @State var colorChanged = false
    @State var viewModel = ViewModel()
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
                .background(viewModel.themeColor)
                LazyVGrid(columns: columns, spacing: 10) {
                    Button(action: {
                        UserDefaults.standard.set(0, forKey: "appearance")
                        colorChanged = true
                    }) {
                        ZStack(){
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(viewModel.themeColor)
                            VStack(){
                                Image(systemName: "sun.max.circle.fill")
                                    .resizable()
                                    .frame(width: itemWidth*0.7, height: itemWidth*0.7)
                                    .padding(20)
                                    .foregroundColor(.white)
                                Text("Light")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    Button(action: {
                        UserDefaults.standard.set(1, forKey: "appearance")
                        colorChanged = true
                    }) {
                        ZStack(){
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(viewModel.themeColor)
                            VStack(){
                                Image(systemName: "moon.circle.fill")
                                    .resizable()
                                    .frame(width: itemWidth*0.7, height: itemWidth*0.7)
                                    .padding(20)
                                    .foregroundColor(.white)
                                Text("Dark")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    Button(action: {
                        UserDefaults.standard.set(2, forKey: "appearance")
                        colorChanged = true
                    }) {
                        ZStack(){
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(viewModel.themeColor)
                            VStack(){
                                Image(systemName: "circle.righthalf.filled")
                                    .resizable()
                                    .frame(width: itemWidth*0.7, height: itemWidth*0.7)
                                    .padding(20)
                                    .foregroundColor(.white)
                                Text("Auto")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                }
                .padding(10)
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

