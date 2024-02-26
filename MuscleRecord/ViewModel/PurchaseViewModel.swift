//
//  PurchaseViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/11.
//

import UIKit
import StoreKit

@MainActor
class PurchaseViewModel: ObservableObject {
    @Published var products = [Product]()

    func setup() {
        Task {
            do {
                let productIds = Set(["musclerecord.pro"])
                let foundProducts = try await Product.products(for: productIds)
                self.products = foundProducts
            } catch {
                print("Failed to load products: \(error)")
            }
        }
        
        listenForTransactionUpdates()
    }

    func purchase() {
        Task {
            guard let product = products.first else { return }
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        UserDefaults.standard.set(true, forKey: "purchaseStatus")
                        showAlert(title: "購入しました")
                        await transaction.finish()
                    case .unverified:
                        showAlert(title: "購入に失敗しました")
                    }
                default:
                    showAlert(title: "購入に失敗しました")
                }
            } catch {
                showAlert(title: "購入に失敗しました")
                print("Purchase failed: \(error)")
            }
        }
    }

    func restore() {
        Task {
            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    UserDefaults.standard.set(true, forKey: "purchaseStatus")
                    showAlert(title: "購入を復元しました")
                    await transaction.finish()
                case .unverified:
                    showAlert(title: "購入の復元に失敗しました")
                }
            }
        }
    }
    
    private func listenForTransactionUpdates() {
        Task {
            for await transaction in Transaction.updates {
                switch transaction {
                case .verified(let transaction):
                    UserDefaults.standard.set(true, forKey: "purchaseStatus")
                    await transaction.finish()
                case .unverified(_, _):
                    break
                }
            }
        }
    }

    private func showAlert(title: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return }
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            rootViewController.present(alert, animated: true)
        }
    }
}
