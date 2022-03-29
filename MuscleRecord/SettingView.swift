//
//  SettingView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Pro")){
                    FormRowView(icon: "gift", firstText: "Proにアップグレード", secondText: "")
                    FormRowView(icon: "", firstText: "テーマカラー", secondText: "")
                    FormRowView(icon: "circle.righthalf.filled", firstText: "ダークモード", secondText: "OFF")
                    HStack{
                        Image("OrangeIcon")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .cornerRadius(8)
                        Text("アイコン").foregroundColor(Color("FontColor"))
                        Spacer()
                    }
                }
                FormRowView(icon: "questionmark", firstText: "使い方", secondText: "")
                FormRowView(icon: "person", firstText: "アカウント作成", secondText: "")
                FormRowView(icon: "star", firstText: "レビューで応援！", secondText: "")
                FormRowView(icon: "square.and.arrow.up", firstText: "アプリをシェア", secondText: "")
                FormRowView(icon: "envelope", firstText: "ご意見・ご要望", secondText: "")
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            Text("Copyright ©︎ All rights reserved. \nMusa Yazuju")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.top, 6)
                .padding(.bottom, 8)
                .foregroundColor(Color.secondary)
        }.background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
