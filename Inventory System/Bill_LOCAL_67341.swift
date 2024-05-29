//
//  Bill.swift
//  Inventory System
//
//  Created by DaiTran on 26/5/24.
//

import Foundation
class Bill{
    //MARK: Properties
    var products: [Product] = []
    var date: Date
    
    //MARK: init
    init(products: [Product]) {
        self.products = products
        self.date = Date.now
    }
}
