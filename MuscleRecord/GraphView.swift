//
//  GraphView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct GraphView: View {
    @State var selectedIndex = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("event", selection: .constant(1), content: {
                ForEach(0..<30) { num in
                    Text("ここに文章が入ります").font(.headline)
                }
            })
            .pickerStyle(WheelPickerStyle())
            .frame(height: 104)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("AccentColor"), lineWidth: 3)
            )
            Picker("period", selection: self.$selectedIndex, content: {
                Text("毎日").tag(0)
                Text("3日平均").tag(1)
                Text("週平均").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
            HStack(spacing: 0) {
                VStack(spacing: 20) {
                    ForEach(0..<13) { num in
                        Text("60")
                            .foregroundColor(Color("AccentColor"))
                            .font(.footnote)
                    }
                }
                .frame(minWidth: 15, minHeight: 0, maxHeight: .infinity)
                .padding(.bottom, 30)
                .padding(.trailing, 10)
                Rectangle()
                .foregroundColor(Color("AccentColor"))
                .frame(width: 3)
                .padding(.bottom, 30)
                ScrollViewReader{ proxy in
                    ScrollView(.horizontal){
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(0..<100) { num in
                                VStack(spacing: 0){
                                    Spacer()
                                    Rectangle()
                                        .frame(width: 30, height: 300)
                                        .foregroundColor(Color("AccentColor"))
                                        .overlay(VStack{
                                            Spacer()
                                            Text("10")
                                                .foregroundColor(.white)
                                                .padding(.bottom, 5)
                                        })
                                    Rectangle()
                                        .frame(width: 40, height: 3)
                                        .foregroundColor(Color("AccentColor"))
                                    Text("12/22")
                                        .frame(width: 34)
                                        .foregroundColor(Color("AccentColor"))
                                        .font(.footnote)
                                        .padding(.bottom, 10)
                                        .padding(.top, 4)
                                }.id(num)
                            }
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                    }.onAppear{
                        proxy.scrollTo(99)
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }.padding(10)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
