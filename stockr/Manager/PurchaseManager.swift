//
//  PurchaseManager.swift
//  stockr
//
//  Created by Joschua Marz on 06.12.20.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    
    override init() {
        super.init()
        fetchProducts()
    }
    
    var premiumProduct: SKProduct?
    var delegate: PremiumDelegate?
    
    func startPurchase() {
        guard let premiumProduct = premiumProduct else {
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: premiumProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.finevisuals.stockr.premium"])
        request.delegate = self
        request.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            premiumProduct = product
            print(product.productIdentifier)
            print(product.price)
            print(product.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                //nothing todo
                break
            case .purchased, .restored:
                //unlock
                UserDefaults.standard.setValue(true, forKey: "premium")
                delegate?.subsripted()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    
    
    
}
