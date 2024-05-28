//
<<<<<<< HEAD
//  Bill.swift
//  Inventory System
//
//  Created by DaiTran on 26/5/24.
=======
//  Bills.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
>>>>>>> main
//

import Foundation
class Bill{
<<<<<<< HEAD
    //MARK: Properties
    var products: [Product] = []
    var date: Date
    
    //MARK: init
    init(products: [Product]) {
        self.products = products
        self.date = Date.now
=======
    //Mark: Properties
    var id:Int32 = -1
    var customerID: Int32
    var status: Int32
    var date: Date
    
    // Constructor
    init(id: Int32 = -1, customerID: Int32, status: Int32, date: Date) {
        self.id = id
        self.customerID = customerID
        self.status = status
        self.date = date
>>>>>>> main
    }
}
