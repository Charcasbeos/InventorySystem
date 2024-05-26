//
//  Customer.swift
//  Inventory System
//


import UIKit

class Customer {
    //MARK : Properties
    var name: String
    var phoneNumber : String
    var accumulatedMoney : Int
    
    //MaRK : Constructor
    
    init?(name: String, phoneNumber: String, accumulatedMoney: Int) {
        if(name.isEmpty){
            return nil
        }
        if(phoneNumber.isEmpty){
            return nil
        }
        self.name = name
        self.phoneNumber = phoneNumber
        self.accumulatedMoney = accumulatedMoney
    }
    
    
}
