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
    func getPrice() -> String
    
    func getDescription() -> String
    func getCountry() -> String
    func getSector() -> String
    func getIndustry() -> String
    func getExchange() -> String
    func getEmployees() -> String
    func getEbitda() -> String
    func getMarketCapitalization() -> String
    func getYearHigh() -> String
    func getYearLow() -> String
    func getDividendYield() -> String
    func getPeRatio() -> String
    func getAvg200Day() -> String
    func getAvg50Day() -> String
    func getEnabled() -> Bool
}


