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
    
    
<<<<<<< .merge_file_Br3bBQ
    //MARK : Constructor
    init?( name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
=======
    //MaRK : Constructor
    init?(id:Int32 = -1 , name: String, image:UIImage? = nil, unit: String, profit: Double, quantity: Int, cost: Double) {
>>>>>>> .merge_file_Q9W1hK
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
