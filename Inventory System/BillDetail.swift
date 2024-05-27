//
//  BillDetail.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
//

import Foundation
class BillDetail{
    //Properties
    var billID:Int32 = -1
    var productID:Int32
    var productName:String
    var productProfit:Double
    var productCost:Double
    var quantity:Int
    //Constructor
    init(billID: Int32 = -1, productID: Int32, productName: String, productProfit: Double, productCost: Double, quantity: Int) {
        self.billID = billID
        self.productID = productID
        self.productName = productName
        self.productProfit = productProfit
        self.productCost = productCost
        self.quantity = quantity
    }
}
