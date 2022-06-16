//
//  PurchaseViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/11.
//

import Foundation
import StoreKit

class PurchaseViewModel: NSObject, ObservableObject {
    var products = [SKProduct]()
    //初期設定
    func setup() {
        let request = SKProductsRequest(productIdentifiers: [R.string.localizable.proIdentifier()])
        request.delegate = self
        request.start()
    }
    //購入
    func purchase() {
        guard let product = products.first else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    //復元
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        SKPaymentQueue.default().add(self)
    }
    //購入後のアラート
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: R.string.localizable.unlockedAllFeatures(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
        Window.first!.rootViewController?.present(alert, animated: true)
    }
}
//情報取得後
extension PurchaseViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
}
//transactions変更時
extension PurchaseViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchasing: print("purchasing")
            case .purchased:
                print("purchased")
                UserDefaults.standard.set(true, forKey: R.string.localizable.purchaseStatus())
                showAlert(title: R.string.localizable.purchased())
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("restored")
                UserDefaults.standard.set(true, forKey: R.string.localizable.purchaseStatus())
                showAlert(title: R.string.localizable.restored())
                SKPaymentQueue.default().finishTransaction($0)
            case .deferred: print("defferred")
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction($0)
            default: break
            }
        }
    }
}
