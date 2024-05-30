//
//  Bills.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
//

import Foundation
class Bill{
    //Mark: Properties
    var id:Int32 = -1
    var customerID: Int32
    var status: Int32
    var date: String
    
    // Constructor
    init(id: Int32 = -1, customerID: Int32, status: Int32, date: String) {
        self.id = id
        self.customerID = customerID
        self.status = status
        self.date = date
    }
}
