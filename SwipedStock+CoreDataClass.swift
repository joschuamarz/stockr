//
//  SwipedStock+CoreDataClass.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//
//

import UIKit
import CoreData

@objc(SwipedStock)
public class SwipedStock: NSManagedObject, Stock {
    
    
    

    convenience init? (symbol: String, isin: String, wkn: String, name: String?, price: String?, description: String?, country: String?, region: String?, sector: String?, industry: String?, exchange: String?, employees: String?, ebitda: String?, market_capitalization: String?, year_high: String?, year_low: String?, dividend_yield: String?, pe_ratio: String?, moving_avg_200_day: String?, moving_avg_50_day: String?, enabled: Bool?, last_api_sync_at: String?, updated_at: String?, watched: Bool ) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: SwipedStock.entity(), insertInto: context)
        
        self.symbol = symbol
        self.isin = isin
        self.wkn = wkn
        self.name = name
        self.descriptionText = description
        self.country = country
        self.region = region
        self.sector = sector
        self.industry = industry
        self.exchange = exchange
        self.employees = employees
        self.ebitda = ebitda
        self.market_capitalization = market_capitalization
        self.year_high = year_high
        self.year_low = year_low
        self.dividend_yield = dividend_yield
        self.pe_ratio = pe_ratio
        self.moving_avg_200_day = moving_avg_200_day
        self.moving_avg_50_day = moving_avg_50_day
        self.enabled = enabled ?? false
        self.last_api_sync_at = last_api_sync_at
        self.updated_at = updated_at
        self.watched = watched
        self.price = price
    }

    
    func getSymbol() -> String {
        return self.symbol
    }
    
    func getName() -> String {
        return self.name ?? "err"
    }
    
    func getIsin() -> String {
        return self.isin
    }
    
    func getWkn() -> String {
        return wkn
    }
    
    func getPrice() -> Double {
        let price = (Double((self.price ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    
    func getDescription() -> String {
        return self.descriptionText ?? "err"
    }
    
    func getCountry() -> String {
        return self.country ?? "err"
    }
    
    func getSector() -> String {
        return self.sector ?? "err"
    }
    
    func getIndustry() -> String {
        return self.industry ?? "err"
    }
    
    func getExchange() -> String {
        return self.exchange ?? "err"
    }
    
    func getEmployees() -> String {
        return self.employees ?? "err"
    }
    
    func getEbitda() -> Double {
        let price = (Double((self.ebitda ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getMarketCapitalization() -> Double {
        let price = (Double((self.market_capitalization ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getYearHigh() -> Double {
        let price = (Double((self.year_high ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getYearLow() -> Double {
        let price = (Double((self.year_low ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getDividendYield() -> String {
        return self.dividend_yield ?? "err"
    }
    
    func getPeRatio() -> String {
        return self.pe_ratio ?? "err"
    }
    
    func getAvg200Day() -> Double {
        let price = (Double((self.moving_avg_200_day ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getAvg50Day() -> Double {
        let price = (Double((self.moving_avg_50_day ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0.0)*CurrencyConverter().getCurrencyFaktor()
        return price
    }
    
    func getEnabled() -> Bool {
        return self.enabled
    }
    
    //MARK: -Save
    
    func save() {
        guard let managedContext = self.managedObjectContext else {
            return
        }
        
        do {
            try managedContext.save()
            print("gespeichert")
        } catch {
            print("Stock konnte nicht gespeichert werden")
        }
    }
}
