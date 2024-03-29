//
//  StocksManager.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//


import UIKit
import CoreData

class StocksManager {
    
    init() {
        loadedStocks = LoadedStocksManager().fetchLoadedStocks()
        swipedStocks = SwipedStocksManager().fetchSwipedStocks()
        
        unswipedStocks = getUnswipedStock()
        watchedStocks = getWatchedStocks()
    
    }
    
    
    var loadedStocks = [LoadedStock]()
    var swipedStocks = [SwipedStock]()
    var watchedStocks = [SwipedStock]()
    var unswipedStocks = [LoadedStock]()
    
    func getFirst() -> LoadedStock? {
        return unswipedStocks.first
    }
    
    func getSecond() -> LoadedStock? {
        if unswipedStocks.count >= 2 {
            return unswipedStocks[1]
        } else {
            return nil
        }
    }
    
    func swiped(watched: Bool) {
        if let rawStock = getFirst() {
        
            if let swipedStock = SwipedStock(
                symbol: rawStock.symbol,
                isin: rawStock.isin,
                wkn: rawStock.wkn,
                name: rawStock.name,
                price: rawStock.price,
                description: rawStock.descriptionText,
                country: rawStock.country,
                region: rawStock.region,
                sector: rawStock.sector,
                industry: rawStock.industry,
                exchange: rawStock.exchange,
                employees: rawStock.employees,
                ebitda: rawStock.ebitda,
                market_capitalization: rawStock.market_capitalization,
                year_high: rawStock.year_high,
                year_low: rawStock.year_low,
                dividend_yield: rawStock.dividend_yield,
                pe_ratio: rawStock.pe_ratio,
                moving_avg_200_day: rawStock.moving_avg_200_day,
                moving_avg_50_day: rawStock.moving_avg_50_day,
                enabled: rawStock.enabled,
                last_api_sync_at: rawStock.last_api_sync_at,
                updated_at: rawStock.updated_at,
                watched: watched) {
                swipedStocks.append(swipedStock)
                if swipedStock.watched {
                    watchedStocks.append(swipedStock)
                }
                
                swipedStock.save()
            }
            
            unswipedStocks.removeFirst()
        }
    }
    
    func getUnswipedStock() -> [LoadedStock] {
        var stocks = [LoadedStock]()
        for stock in loadedStocks {
            if !SwipedStocksManager().contains(symbol: stock.symbol) && !stock.isEmpty {
                stocks.append(stock)
            } else if stock.isEmpty {
                print("empty stock: \(stock.getName())")
            }
        }
        
        return stocks
    }
    
    func getWatchedStocks() -> [SwipedStock] {
        var stocks = [SwipedStock]()
        for stock in SwipedStocksManager().fetchSwipedStocks() {
            if stock.watched {
                stocks.append(stock)
            }
        }
        
        return stocks
    }
   
    func toUnwatched(stock: Stock) {
        if let watchedStock = stock as? SwipedStock {
            watchedStock.watched = false
            watchedStock.save()
        }
    }
    
    func resetUnwatchedStocks(completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for stock in swipedStocks {
            if !stock.watched {
                managedContext.delete(stock)
            }
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Konnte nicht gespeichert werden")
        }
        
        completion()
    }
}
