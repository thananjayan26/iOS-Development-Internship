//
//  DeliveryAddress+CoreDataProperties.swift
//  
//
//  Created by Thananjayan Selvarajan on 20/11/23.
//
//

import Foundation
import CoreData


extension DeliveryAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryAddress> {
        return NSFetchRequest<DeliveryAddress>(entityName: "DeliveryAddress")
    }

    @NSManaged public var deliveryAddress: String?

}
