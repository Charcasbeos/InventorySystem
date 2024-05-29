//  UIProductStepper.swift
//  Inventory System
//
//  Created by DaiTran on 25/5/24.
//

import UIKit
import OSLog

class UIProductStepper: UIStackView, UITextFieldDelegate{
    
    weak var delegate: UIProductStepperDelegate?
    private var isProgrammaticallyUpdating = false
    
    private var _quantityValue: Int = 0 {
        didSet {
            updateUI()
            if !isProgrammaticallyUpdating {
                delegate?.productStepper(self, didChangeQuantity: _quantityValue)
            }
            os_log("quantiy value: \(self._quantityValue)")
        }
    }
    
    var quantityValue: Int {
        get {
            return _quantityValue
        }
        set {
            if newValue <= maximumValue {
                _quantityValue = newValue
            }
        }
    }
    
    private let maximumValue = 99
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 99
        stepper.minimumValue = 0
        stepper.value = 0
        stepper.stepValue = 1
        return stepper
    }()
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        _quantityValue = Int(sender.value)
        os_log("Stepper value changed: %d", _quantityValue)
    }
    
    @objc func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, let textValue = Int(text), textValue <= maximumValue {
            _quantityValue = textValue
            os_log("TextField value changed: %@", text)
        } else {
            sender.text = "\(_quantityValue)" // Reset to the valid value
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        axis = .horizontal
        distribution = .fill
        alignment = .center
        
        quantityTextField.delegate = self
        
        addArrangedSubview(quantityTextField)
        addArrangedSubview(stepper)
        
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        quantityTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        
        
        updateUI()
    }
    
    private func updateUI() {
        quantityTextField.text = "\(_quantityValue)"
        stepper.value = Double(_quantityValue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty{
            if _quantityValue < 10 && _quantityValue > 0{
                _quantityValue -= 1
            }
            updateUI()
            os_log("Delete button pressed")
        }
        return true
    }
    
    func setProgrammaticValue(_ value: Int) {
        isProgrammaticallyUpdating = true
        quantityValue = value
        isProgrammaticallyUpdating = false
    }
    
}
