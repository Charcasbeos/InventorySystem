//
//  UIProductStepper.swift
//  Inventory System
//
//  Created by DaiTran on 25/5/24.
//

import UIKit

class UIProductStepper: UIStackView {
    
    private var _quantityValue:Int = 0 {
        didSet{
            
        }
    }
    private let maximumValue = 99
    
    private let quantityTextField = {
        let textField  = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    private let stepper:UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 99
        stepper.minimumValue = 0
        stepper.value = 0
        stepper.stepValue = 1
        return stepper
    }()
    
    @IBAction func stepper(_ sender: UIStepper) {
    }
    
    @IBAction func textFieldValue(_ sender: UITextField) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
     
    func setUpView(){
        axis = .horizontal
        distribution = .fill
        alignment = .center
        
        
        
    }
    
}
