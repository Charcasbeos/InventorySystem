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
    
    
    //MaRK : Constructor
    init?(id:Int32 = -1 , name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
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
    // Implementing Equatable and Hashable
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
