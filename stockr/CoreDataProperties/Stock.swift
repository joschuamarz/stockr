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

extension String {
    func getRounded(to places: Int) -> String {
        let value = Double(self.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let divisor = pow(10.0, Double(places))
        let result = (value * divisor).rounded() / divisor
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: result)) ?? "err"
    }
    
    func getSeperated() -> String {
        let value = Int(Double(self) ?? 0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value)) ?? "err"
    }
    
    func getPercentage() -> String {
        let value = Double(self) ?? 0.0
        let percentage = value*100
        let divisor = pow(10.0, Double(2))
        let result = (percentage * divisor).rounded() / divisor
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: result)) ?? "err"
    }
}
