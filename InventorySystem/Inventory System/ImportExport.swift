//
//  ImportExport.swift
//  Inventory System
//
//  Created by tran thu on 23/05/2024.
//

import Foundation
class ImportExport{
    var date:Date
    var cost:Double
    var quantity:Int
    var productID:Int
    
    init( productID: Int, quantity: Int, cost: Double,date: Date) {
        self.date = date
        self.cost = cost
        self.quantity = quantity
        self.productID = productID
    }
}
