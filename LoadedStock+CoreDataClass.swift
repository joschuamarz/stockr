//
//  LoadedStock+CoreDataClass.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//
//

import UIKit
import CoreData

@objc(LoadedStock)
public class LoadedStock: NSManagedObject {
    
    convenience init? (symbol: String, isin: String, name: String?, description: String?, country: String?, sector: String?, industry: String?, exchange: String?, employees: String?, ebitda: String?, market_capitalization: String?, year_high: String?, year_low: String?, dividend_yield: String?, pe_ratio: String?, moving_avg_200_day: String?, moving_avg_50_day: String?, enabled: Bool?, last_api_sync_at: String?, updated_at: String?) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: LoadedStock.entity(), insertInto: context)
        
        self.symbol = symbol
        self.isin = isin
        self.name = name
        self.descriptionText = description
        self.country = country
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
