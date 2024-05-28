//
//  Product.swift
//  Inventory System
//
//  Created by tran thu on 22/05/2024.
//

import Foundation
import UIKit
class Product : Hashable {
    //MARK : Properties
    var id:Int32 = -1
    var name: String
    var image:UIImage?
    var unit : String
    var cost : Double
    var profit : Double
    var quantity : Int
    
    
<<<<<<<<< Temporary merge branch 1
    //MaRK : Constructor
    init?(id:Int32 = -1 , name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
=========
    //MARK : Constructor
    init?( name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
>>>>>>>>> Temporary merge branch 2
        if name.isEmpty || unit.isEmpty{
            return nil
        }
        self.id = id
        self.name = name
        self.image = image
        self.unit = unit
        self.cost = cost
        self.profit = profit
        self.quantity = quantity
    }
    
    //MARK: - Hashable
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.unit == rhs.unit && lhs.cost == rhs.cost && lhs.profit == rhs.profit && lhs.quantity == rhs.quantity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(unit)
        hasher.combine(cost)
        hasher.combine(profit)
        hasher.combine(quantity)
    }
}
