//
//  Product.swift
//  Inventory System
//
//  Created by tran thu on 22/05/2024.
//

import Foundation
import UIKit
class Product {
    //MARK : Properties
    var id:Int
    var name: String
    var image:UIImage?
    var unit : String
    var cost : Double
    var profit : Double
    var quantity : Int
    
    
    //MaRK : Constructor
    init?( name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
        if name.isEmpty || unit.isEmpty{
            return nil
        }
        self.id = 0
        self.name = name
        self.image = image
        self.unit = unit
        self.cost = cost
        self.profit = profit
        self.quantity = quantity
    }
    
}
