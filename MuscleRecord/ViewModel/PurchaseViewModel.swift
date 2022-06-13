//
//  PurchaseViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/11.
//

import SwiftUI
import RevenueCat

class PurchaseViewModel: ObservableObject {
    @Published var shouldPopToRootView = true
    @Published var isShowingAlert = false
    //内課金購入状態
    func isPurchased() -> Bool {
        var isPro = false
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            guard error == nil else {
                print("内課金購入時のエラー\(error!)")
                return
            }
            if customerInfo?.entitlements[R.string.localizable.pro()]?.isActive == true {
                isPro = true
            }
        }
        return isPro
    }
    //内課金購入
    func purchase() {
        Purchases.shared.getOfferings { (offerings, error) in
            guard error == nil else {
                print("内課金取得時のエラー\(error!)")
                return
            }
            guard let package = offerings?.current?.lifetime?.storeProduct else { return }
            Purchases.shared.purchase(product: package) { (transaction, customerInfo, error, userCancelled) in
                guard error == nil else {
                    print("内課金購入時のエラー\(error!)")
                    return
                }
                if customerInfo?.entitlements.all[R.string.localizable.pro()]?.isActive == true {
                    self.shouldPopToRootView = false
                }
            }
        }
    }
    //内課金復元
    func restore() {
        Purchases.shared.restorePurchases { customerInfo, error in
            guard error == nil else {
                print("内課金復元時のエラー\(error!)")
                return
            }
            if customerInfo?.entitlements.all[R.string.localizable.pro()]?.isActive == true {
                self.isShowingAlert = true
            }
        }
    }
}
