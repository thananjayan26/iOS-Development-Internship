//
//  AppCoreData.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 07/11/23.
//

import Foundation
import CoreData
import UIKit

class AppCoreData {
    static let instance = AppCoreData()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //UserInformation:
    func createUserInformation(userName: String, userEmail: String, userImage: Data?) {
        let newUserInfo = UserInformation(context: context)
        newUserInfo.userName = userName
        newUserInfo.userEmail = userEmail
        newUserInfo.userImageData = userImage
        do {
            try context.save()
        } catch {
            print("Error saving new user info")
        }
    }
    
    func getUserInformation() -> UserInformation? {
        do {
            let userInfo = try context.fetch(UserInformation.fetchRequest())
            print("user info: \(userInfo)")
            if userInfo.isEmpty {
                return nil
            } else {
                return userInfo.first
            }
        } catch {
            print("Error getting user info")
            return nil
        }
    }
    
    func deleteUserInfo() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: UserInformation.description())
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting user info")
        }
    }
    
    
    //OrderDetails:
    func addDishToOrder(dishId: Int, dishName: String, dishQuantity: Int, dishPrice: Double) {
        let newDishInfo = OrderDetails(context: context)
        newDishInfo.dishID = Int16(dishId)
        newDishInfo.dishName = dishName
        newDishInfo.dishQuantity = Int16(dishQuantity)
        newDishInfo.dishPrice = dishPrice
        do {
            try context.save()
        } catch {
            print("Error saving new order info")
        }
    }
    
    func getOrderDetails() -> [OrderDish] {
        var result: [OrderDish] = []
        do {
            let orderDetails = try context.fetch(OrderDetails.fetchRequest())
            for item in orderDetails {
                result.append(OrderDish(dishID: Int(item.dishID), vegetarian: true, dishName: item.dishName!, dishQuantity: Int(item.dishQuantity), dishPrice: item.dishPrice))
            }
            return result
        } catch {
            print("Error getting order info")
            return []
        }
    }
    
    func getOrderDishID() -> Dictionary<Int, Int> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: OrderDetails.description())
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = ["dishID", "dishQuantity"]
        
        do {
            let listOfID = try context.fetch(fetchRequest)
            print("list of id: \(listOfID)")
            var result: Dictionary<Int, Int> = [:]
            for item in listOfID {
                result[item.value(forKey: "dishID") as! Int] = (item.value(forKey: "dishQuantity") as! Int)
            }
            print(result)
            return result
        } catch {
            print("error getting dish ids")
            return [0:0]
        }
    }
    
    func deleteOrderDetails() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: OrderDetails.description())
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting order info")
        }
    }
    
    func deleteSpecificOrderDetail(dishID: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: OrderDetails.description())
        // Create Batch Delete Request
        fetchRequest.predicate = NSPredicate(format: "dishID == %d", dishID)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting order info")
        }
    }
    
    func checkIfDishInOrder(dishID: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: OrderDetails.description())
        fetchRequest.predicate = NSPredicate(format: "dishID == %d", dishID)
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error checking dish in order")
            return false
        }
    }
    
    func updateDishDetailOrder(dishID: Int, dishQuantity: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: OrderDetails.description())
        fetchRequest.predicate = NSPredicate(format: "dishID == %d", dishID)
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count != 0 {
                fetchResult[0].setValue(Int16(dishQuantity), forKey: "dishQuantity")
            } else { return }
        } catch {
            print("Error getting order detail to update")
            return
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    func getNumberOfItems() -> Int? {
        let keypathExp1 = NSExpression(forKeyPath: "dishQuantity")
        let expression = NSExpression(forFunction: "sum:", arguments: [keypathExp1])
        let sumDesc = NSExpressionDescription()
        sumDesc.expression = expression
        sumDesc.name = "sum"
        sumDesc.expressionResultType = .integer64AttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: OrderDetails.description())
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [sumDesc]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let itemNumber = try context.fetch(fetchRequest) as! [Dictionary<String, Int>]
            return itemNumber[0]["sum"]
        } catch {
            print("Error getting sum of items")
            return nil
        }
    }
    
    func getOrderTotal() -> Int {
        let keypathExp1 = NSExpression(forKeyPath: "dishQuantity")
        let keypathExp2 = NSExpression(forKeyPath: "dishPrice")
        let expression = NSExpression(forFunction: "multiply:by:", arguments: [keypathExp1, keypathExp2])
        let productDesc = NSExpressionDescription()
        productDesc.expression = expression
        productDesc.name = "product"
        productDesc.expressionResultType = .doubleAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: OrderDetails.description())
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [productDesc]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let itemNumber = try context.fetch(fetchRequest) as! [Dictionary<String, Double>]
            var total = 0.0
            for item in itemNumber {
                total += item["product"] ?? 0.0
            }
            return Int(total.rounded())
        } catch {
            print("Error getting product of items")
            return 0
        }
    }
    
    //Delivery Address
    func setSelectedAddress(selectedAddress: String) {
        let address = DeliveryAddress(context: context)
        address.deliveryAddress = selectedAddress
        do {
            try context.save()
        } catch {
            print("Error setting selected address \(error)")
        }
    }
    
    func getSelectedAddress() -> String? {
        do {
            let address = try context.fetch(DeliveryAddress.fetchRequest())
            print(address)
            if !address.isEmpty {
                return address.last?.deliveryAddress
            }
        } catch {
            print("Error getting selected address \(error)")
        }
        return nil
    }
}
