//
//  ProView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct ProView: View {
    @ObservedObject private var purchaseViewModel = PurchaseViewModel()
    
    init() {
        purchaseViewModel.setup()
    }
    
    var body: some View {
        SimpleNavigationView(title: String(localized: "proViewTitle")) {
            ScrollView {
                VStack(spacing: 10) {
                    //アイコン解放
                    ProTitleView(icon: "Logo", title: String(localized: "unlockIcon"), isImage: true)
                    Image("Icons")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    //テーマカラー解放
                    ProTitleView(icon: "hammer.circle.fill", title: String(localized: "unlockTheme"), isImage: false)
                    themes
                    //種目数解放
                    ProTitleView(icon: "lock.circle.fill", title: String(localized: "unlockEvents"), isImage: false)
                    //購入ボタン
                    Button( action: {
                        purchaseViewModel.purchase()
                    }, label: {
                        ButtonView("purchase").padding(.top, 10)
                    })
                    //復元ボタン
                    Button( action: {
                        purchaseViewModel.restore()
                    }, label: {
                        ButtonView("restore").padding(.top, 10)
                    })
                }.padding(.horizontal, 20)
            }
        }
    }
    
    private var themes: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                themeItem(.themeColor0)
                themeItem(.themeColor1)
                themeItem(.themeColor2)
            }
            HStack(spacing: 4) {
                themeItem(.themeColor3)
                themeItem(.themeColor4)
                themeItem(.themeColor5)
            }
        }
    }
    
    private func themeItem(_ color: ColorResource) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundStyle(Color(color))
            .frame(height: 50)
    }
}

#Preview {
    ProView()
}
