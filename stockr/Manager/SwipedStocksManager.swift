//
//  SwipedStocksManager.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit
import CoreData

class SwipedStocksManager {
    
    
    func contains(symbol: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SwipedStock")
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            
            guard let resultsArr = try managedContext.fetch(fetchRequest) as? [SwipedStock] else {
                return false
            }
            
            if resultsArr.count > 0 {
                return true
            } else {
                return false
            }
           
            
            
            
           
        } catch {
            
            return false
        }
        
    }
    
    func fetchSwipedStocks() -> [SwipedStock] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SwipedStock> = SwipedStock.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
            
            
        } catch {
            print("Swiped Stocks konnten nicht geladen werden")
            return []
        }
    }
}
