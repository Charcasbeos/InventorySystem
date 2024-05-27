//
//  AddCustomController.swift
//  Inventory System
//
//  Created by Do Ngoc Hieu on 22/05/2024.
//

import UIKit

class AddCustomController: UIViewController ,UITextFieldDelegate{

    

    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var inputName: UITextField!
    
    @IBOutlet weak var inputPhone: UITextField!
    
    @IBOutlet weak var testSave: UIBarButtonItem!
    
    //Bien luu tru chuyen 2 man hinh
    var customer:Customer?
    //Gan gia tri
    var accumalated:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Dinh nghia cac ham uy quyen cua UITextField
        //chi dinh doi tuong
        inputName.delegate = self
        inputPhone.delegate = self
        //set kieu input
        inputName.keyboardType = .default
        inputPhone.keyboardType = .numbersAndPunctuation
         
        // Lay du lieu truyen sang tu man hinh list customer
        if let customer = customer {
            navigation.title = customer.name
            inputName.text = customer.name
            inputPhone.text = customer.phoneNumber
            accumalated = customer.accumulatedMoney > 0.0 ? customer.accumulatedMoney : 0.0
        }
        testSave.isEnabled = false
        
    }
    // Custom keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Kiểm tra nếu textField là phone (nhập số)
        if textField == inputPhone {
            // Chỉ cho phép nhập các ký tự số.
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
        
            // Kiểm tra ký tự nhập , nếu không cho phep thi kh nhap dc
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            return true
        }
        
        // Cho phép thay đổi cho tất cả các trường hợp khác
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // an ban phim
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigation.title = "Add : " + inputName.text!
       
    }
    
    //Xu ly save khi dang nhap du lieu
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        //Kiem tra so dien thoai co 10 chu so khong
        var isPhoneNumberValid: Bool{
            return inputPhone.text!.count == 10
        }
        //Kiem tra ten tren 6 ky tu
        var isNameValid: Bool{
            return inputName.text!.count > 6
        }
        if isPhoneNumberValid && isNameValid {
            testSave.isEnabled = true
            return
        }
        else {
            testSave.isEnabled = false
            return
        }
    }
    
    
    //nut thoat
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Chuan bi du lieu de add hoac edit sang list customer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Tao doi tuong de chuyen man hinh
        let name = inputName.text ?? ""
        let phone = inputPhone.text ?? ""
        customer = Customer(name: name, phoneNumber: phone, accumulatedMoney: accumalated)
    }
    

}
