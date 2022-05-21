//
//  ProView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/13.
//

import SwiftUI
import RevenueCat

struct ProView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var shouldPopToRootView : Bool
    @ObservedObject var viewModel = ViewModel()
    @State private var showAlert = false
    var body: some View {
        SimpleNavigationView(title: "Proをアンロック") {
            ScrollView(){
                VStack(spacing: 10){
                    ProTitleView(icon: "Logo", title: "アイコン解放", isImage: true)
                    Image("Icons")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    ProTitleView(icon: "hammer.circle.fill", title: "テーマカラー解放", isImage: false)
                    Image("Themes")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    ProTitleView(icon: "lock.circle.fill", title: "種目数：5個 → 無制限", isImage: false)
                    Button( action: {
                        Purchases.shared.getOfferings { (offerings, error) in
                            if let package = offerings?.current?.lifetime?.storeProduct {
                                Purchases.shared.purchase(product: package) { (transaction, customerInfo, error, userCancelled) in
                                    if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                                        shouldPopToRootView = false
                                    }
                                }
                            }
                        }
                    }, label: {
                        ButtonView(text: "Proをアンロック - 490円")
                            .padding(.top, 20)
                    })
                    Button( action: {
                        Purchases.shared.restorePurchases { customerInfo, error in
                            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                                showAlert = true
                            }
                        }
                    }, label: {
                        ButtonView(text: "過去の購入を復元")
                            .padding(.top, 20)
                    })
                }
                .padding(20)
                .alert("購入を復元しました", isPresented: $showAlert) {
                    Button("OK") {
                        shouldPopToRootView = false
                    }
                }
            }
        }
    }
}
