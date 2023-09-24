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
        SimpleNavigationView(title: "Proをアンロック") {
            ScrollView {
                VStack(spacing: 10) {
                    //アイコン解放
                    ProTitleView(icon: "Logo", title: "アイコン解放", isImage: true)
                    ProImageView(image: "Icons")
                    //テーマカラー解放
                    ProTitleView(icon: "hammer.circle.fill", title: "テーマカラー解放", isImage: false)
                    ProImageView(image: "Themes")
                    //種目数解放
                    ProTitleView(icon: "lock.circle.fill", title: "種目数：5個 → 無制限", isImage: false)
                    ProImageView(image: "Items")
                    //購入ボタン
                    Button( action: {
                        purchaseViewModel.purchase()
                    }, label: {
                        ButtonView(text: "Proをアンロック - 300円").padding(.top, 10)
                    })
                    //復元ボタン
                    Button( action: {
                        purchaseViewModel.restore()
                    }, label: {
                        ButtonView(text: "過去の購入を復元").padding(.top, 10)
                    })
                }.padding(.horizontal, 20)
            }
        }
    }
}
