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
        SimpleNavigationView(title: R.string.localizable.proViewTitle()) {
            ScrollView {
                VStack(spacing: 10) {
                    //アイコン解放
                    ProTitleView(icon: R.string.localizable.logo(), title: R.string.localizable.unlockIcon(), isImage: true)
                    ProImageView(image: R.string.localizable.icons())
                    //テーマカラー解放
                    ProTitleView(icon: R.string.localizable.hammerIcon(), title: R.string.localizable.unlockTheme(), isImage: false)
                    ProImageView(image: R.string.localizable.themes())
                    //種目数解放
                    ProTitleView(icon: R.string.localizable.lockIcon(), title: R.string.localizable.unlockEvents(), isImage: false)
                    ProImageView(image: R.string.localizable.items())
                    //購入ボタン
                    Button( action: {
                        purchaseViewModel.purchase()
                    }, label: {
                        ButtonView(text: R.string.localizable.purchase()).padding(.top, 10)
                    })
                    //復元ボタン
                    Button( action: {
                        purchaseViewModel.restore()
                    }, label: {
                        ButtonView(text: R.string.localizable.restore()).padding(.top, 10)
                    })
                }.padding(.horizontal, 20)
            }
        }
    }
}
