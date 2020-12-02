//
//  SwipedStock+CoreDataProperties.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//
//

import Foundation
import CoreData


extension SwipedStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SwipedStock> {
        return NSFetchRequest<SwipedStock>(entityName: "SwipedStock")
    }

    @NSManaged public var symbol: String
    @NSManaged public var isin: String
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var country: String?
    @NSManaged public var sector: String?
    @NSManaged public var industry: String?
    @NSManaged public var exchange: String?
    @NSManaged public var employees: String?
    @NSManaged public var ebitda: String?
    @NSManaged public var market_capitalization: String?
    @NSManaged public var year_high: String?
    @NSManaged public var year_low: String?
    @NSManaged public var dividend_yield: String?
    @NSManaged public var pe_ratio: String?
    @NSManaged public var moving_avg_200_day: String?
    @NSManaged public var moving_avg_50_day: String?
    @NSManaged public var enabled: Bool
    @NSManaged public var last_api_sync_at: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var watched: Bool
    

}

extension SwipedStock : Identifiable {

}
