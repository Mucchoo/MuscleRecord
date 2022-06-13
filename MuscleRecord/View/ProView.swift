//
//  ProView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI

struct ProView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = ViewModel()
    @ObservedObject private var purchaseViewModel = PurchaseViewModel()
    @Binding var shouldPopToRootView: Bool
    @State private var isShowingAlert = false
    
    var body: some View {
        SimpleNavigationView(title: R.string.localizable.proViewTitle()) {
            ScrollView(){
                VStack(spacing: 10){
                    //アイコン解放
                    ProTitleView(icon: R.string.localizable.logo(), title: R.string.localizable.unlockIcon(), isImage: true)
                    Image(R.string.localizable.icons())
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    //テーマカラー解放
                    ProTitleView(icon: R.string.localizable.hammerIcon(), title: R.string.localizable.unlockTheme(), isImage: false)
                    Image(R.string.localizable.themes())
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    //種目数解放
                    ProTitleView(icon: R.string.localizable.lockIcon(), title: R.string.localizable.unlockEvents(), isImage: false)
                    //購入ボタン
                    Button( action: {
                        purchaseViewModel.purchase()
                    }, label: {
                        ButtonView(text: R.string.localizable.purchase())
                            .padding(.top, 20)
                    })
                    //復元ボタン
                    Button( action: {
                        purchaseViewModel.restore()
                    }, label: {
                        ButtonView(text: R.string.localizable.restore())
                            .padding(.top, 20)
                    })
                }
                .padding(20)
                //復元時のアラート
                .alert(R.string.localizable.restored(), isPresented: $isShowingAlert) {
                    Button(R.string.localizable.ok()) {
                        shouldPopToRootView = false
                    }
                }
            }
        }.onAppear {
            shouldPopToRootView = purchaseViewModel.shouldPopToRootView
            isShowingAlert = purchaseViewModel.isShowingAlert
        }
    }
}
