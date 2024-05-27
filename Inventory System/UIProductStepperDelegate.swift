//
//  UIProductStepperDelegate.swift
//  Inventory System
//
//  Created by DaiTran on 27/5/24.
//

import Foundation
protocol UIProductStepperDelegate : AnyObject{
    func productStepper(_ stepper: UIProductStepper, didChangeQuantity quantity: Int)
}
