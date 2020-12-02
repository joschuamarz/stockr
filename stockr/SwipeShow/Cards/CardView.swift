//
//  CardView.swift
//  stockr
//
//  Created by Joschua Marz on 02.12.20.
//

import Foundation
import UIKit

protocol CardView: UIView, UIGestureRecognizerDelegate {
    func adjustBackgroundColor(with faktor: CGFloat)
    func swipedRight(manager: StocksManager)
    func swipedLeft(manager: StocksManager)
    func setStock(_ stock: Stock)
    func setStockDelegate(_ delegate: StockCardDelegate)
}
