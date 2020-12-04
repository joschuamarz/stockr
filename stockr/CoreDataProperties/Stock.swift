//
//  Stock.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import Foundation


protocol Stock {
    func getSymbol() -> String
    func getName() -> String
    func getIsin() -> String
    func getPrice() -> Double
    
    func getDescription() -> String
    func getCountry() -> String
    func getSector() -> String
    func getIndustry() -> String
    func getExchange() -> String
    func getEmployees() -> String
    func getEbitda() -> Double
    func getMarketCapitalization() -> Double
    func getYearHigh() -> Double
    func getYearLow() -> Double
    func getDividendYield() -> String
    func getPeRatio() -> String
    func getAvg200Day() -> Double
    func getAvg50Day() -> Double
    func getEnabled() -> Bool
}


