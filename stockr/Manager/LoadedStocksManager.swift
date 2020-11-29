//
//  LoadedStocksManager.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit
import CoreData

class LoadedStocksManager {
    
    
    func fetchLoadedStocks() -> [LoadedStock] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("FactFinder, FetchFacts: Kein AppDelegate gefunden")
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LoadedStock> = LoadedStock.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
            
            
        } catch {
            print("Loaded Stocks konnten nicht geladen werden")
            return []
        }
    }
    
    func deleteOldLoadedStocks(completion: @escaping () -> Void) {
       
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "LoadedStock")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
                completion()
            } catch {
                print ("There was an error")
                }
        
    }
    
    
}
