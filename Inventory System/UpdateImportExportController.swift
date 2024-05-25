//
//  UpdateImportExportController.swift
//  Inventory System
//
//  Created by tran thu on 23/05/2024.
//

import UIKit

class UpdateImportExportController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelName: UILabel!
    //Bien product dung de truyen tham so giua 2 man hinh
        var product:Product?
        var import_export:ImportExport?
    override func viewDidLoad() {
        super.viewDidLoad()
        quantity.keyboardType = .numbersAndPunctuation
        cost.keyboardType = .numbersAndPunctuation
        quantity.delegate = self
        cost.delegate = self
        labelID.text = "\(product!.id)"
        labelName.text = "\(product!.name)"
          
    }
    // Custom keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Kiểm tra nếu textField là cost
        if textField == cost {
            
            // Chỉ cho phép nhập các ký tự số và dấu trừ
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            let currentText = textField.text ?? ""
            
            
            // Kiểm tra ký tự nhập vào có phải là ký tự được cho phép không
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Kiểm tra chỉ có một dấu chấm thập phân
            if string == "." {
                if currentText.contains(".") {
                    return false
                }
            }
            
            // Cho phép thay đổi cho tất cả các trường hợp khác
            return true
        }
        // Kiểm tra nếu textField là quantity
        else if textField == quantity {
            
            // Chỉ cho phép nhập các ký tự số và dấu trừ
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.-")
            let characterSet = CharacterSet(charactersIn: string)
            let currentText = textField.text ?? ""
            
            // Cho phép dấu trừ ở đầu tiên nếu nó chưa tồn tại
            if string == "-" {
                if range.location == 0 && !currentText.contains("-") {
                    return true
                } else {
                    return false
                }
            }
            
            // Kiểm tra ký tự nhập vào có phải là ký tự được cho phép không
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Kiểm tra chỉ có một dấu chấm thập phân
            if string == "." {
                if currentText.contains(".") {
                    return false
                }
            }
            
            // Cho phép thay đổi cho tất cả các trường hợp khác
            return true
        }
        return true
    }
    // MARK: Dinh nghia ham uy quyen text field
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case quantity:
        quantity.resignFirstResponder()
    case cost:
        cost.resignFirstResponder()
    default:
        print("Error!")
    }
    return true
}
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lấy thời gian hiện tại
        let currentDate = Date()
        //tao doi tuong khi có các field khác rỗng
        if let quantity = quantity.text
            ,let cost = cost.text, let product = product{
            if !quantity.isEmpty && !cost.isEmpty{
                import_export = ImportExport(productID: product.id, quantity: Int(quantity)!, cost: Double(cost)!, date: currentDate)
            }
            
        }
    }
    

}
