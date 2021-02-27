//
//  ApiManager.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

struct RawStock: Codable {
    public let id: Int
    public let symbol: String
    public let isin: String
    public let wkn: String
    public let price: String?
    public let name: String?
    public let descriptionText: String?
    public let country: String?
    public let sector: String?
    public let industry: String?
    public let exchange: String?
    public let employees: String?
    public let ebitda: String?
    public let market_capitalization: String?
    public let year_high: String?
    public let year_low: String?
    public let dividend_yield: String?
    public let pe_ratio: String?
    public let moving_avg_200_day: String?
    public let moving_avg_50_day: String?
    public let enabled: Bool?
    public let last_api_sync_at: String?
    public let created_at: String?
    public let updated_at: String?
}

class ApiManager {
    
    
    let urlString = "http://18.184.18.218/api/stocks"
    
   

    
    
    //MARK: -API
    func getStocksFromAPI(completion: @escaping (_ success: Bool) -> Void) {
        CurrencyConverter().updateExchangeRates()
        self.loadJson(fromURLString: self.urlString) { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data, completion: completion)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
        
       
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.async {
            if let url = URL(string: urlString) {
                let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    if let data = data {
                        completion(.success(data))
                    }
                }
                
                urlSession.resume()
            }
        }
        
    }
    
    private func parse(jsonData: Data, completion: @escaping (_ success: Bool) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(Array<RawStock>.self,
                                                       from: jsonData)
            
            print("geladen: ", decodedData.count)
            saveLoadedStocks(decodedData, completion: completion)
            print("===================================")
        } catch {
            print(error)
            completion(false)
            print("decode error")
        }
    }
    
    private func saveLoadedStocks(_ rawStocks: [RawStock], completion: @ escaping (_ success: Bool) -> Void) {
        
        guard rawStocks.count > 0 else {
            completion(false)
            return
        }
        
        let group = DispatchGroup()
        DispatchQueue.main.async {
            group.enter()
            LoadedStocksManager().deleteOldLoadedStocks {
                group.leave()
            }
            
            group.wait()
            for rawStock in rawStocks {
                let _ = LoadedStock(
                    symbol: rawStock.symbol,
                    isin: rawStock.isin,
                    wkn: rawStock.wkn,
                    name: rawStock.name,
                    price: rawStock.price,
                    description: rawStock.descriptionText,
                    country: rawStock.country,
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
                    updated_at: rawStock.updated_at)
            }
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            guard let context = appDelegate?.persistentContainer.viewContext else {
                return
            }
            
            do {
                try context.save()
                completion(true)
            } catch {
                print("LoadedStocks konnten nicht gespeichert werden")
                completion(false)
            }

        }
            
    }
    
    
}


extension Date {

    func stripTimeString() -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return "\(date!)"
    }

}
