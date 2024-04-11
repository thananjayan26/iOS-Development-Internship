//
//  OrderDetails+CoreDataProperties.swift
//  
//
//  Created by Thananjayan Selvarajan on 10/11/23.
//
//

import Foundation
import CoreData


extension OrderDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderDetails> {
        return NSFetchRequest<OrderDetails>(entityName: "OrderDetails")
    }

    @NSManaged public var dishID: Int16
    @NSManaged public var dishName: String?
    @NSManaged public var dishQuantity: Int16
    @NSManaged public var dishPrice: Double

}
