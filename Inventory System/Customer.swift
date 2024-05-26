//
//  Customer.swift
//  Inventory System
//


import UIKit

class Customer {
    //MARK : Properties
    var name: String
    var phoneNumber : String
    var accumulatedMoney : Double
    var id:Int32 = -1
    
    //MaRK : Constructor
    
    init?(name: String, phoneNumber: String, accumulatedMoney: Double, id:Int32 = -1) {
        if(name.isEmpty){
            return nil
        }
        if(phoneNumber.isEmpty){
            return nil
        }
        self.name = name
        self.phoneNumber = phoneNumber
        self.accumulatedMoney = accumulatedMoney
        self.id = id
    }
    
    
}
