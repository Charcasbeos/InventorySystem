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
    //Bien luu tru chuyen 2 man hinh
    var customer:Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Dinh nghia cac ham uy quyen cua UITextField
        inputName.delegate = self
        inputPhone.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // an ban phim
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigation.title = "Add : " + inputName.text!
    }
    //nut thoat
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Tao doi tuong de chuyen man hinh
        let name = inputName.text ?? ""
        let phone = inputPhone.text ?? ""
        customer = Customer(name: name, phoneNumber: phone, accumulatedMoney: 0)
    }
    

}
