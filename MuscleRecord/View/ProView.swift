//
//  ProView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct ProView: View {
    @Environment(\.dismiss) private var dismiss
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
                    ProImageView(image: "Icons")
                    //テーマカラー解放
                    ProTitleView(icon: "hammer.circle.fill", title: String(localized: "unlockTheme"), isImage: false)
                    ProImageView(image: "Themes")
                    //種目数解放
                    ProTitleView(icon: "lock.circle.fill", title: String(localized: "unlockEvents"), isImage: false)
                    ProImageView(image: "Items")
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
}
