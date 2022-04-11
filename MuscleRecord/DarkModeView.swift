//
//  DarkModeView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/10.
//

import SwiftUI

struct DarkModeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model = ViewModel()
    @Binding var isFirstViewActive: Bool
    let itemWidth = (UIScreen.main.bounds.width - 40)/3
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            Button(action: {
                UserDefaults.standard.set(0, forKey: "appearance")
                self.isFirstViewActive = false
            }) {
                ZStack(){
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(model.getThemeColor())
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
                self.isFirstViewActive = false
            }) {
                ZStack(){
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(model.getThemeColor())
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
                self.isFirstViewActive = false
            }) {
                ZStack(){
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(model.getThemeColor())
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
            .navigationTitle("種目を追加")
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
