//
//  UpdateProductTableController.swift
//  Inventory System
//
//  Created by tran thu on 23/05/2024.
//

import UIKit

class UpdateProductController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITabBarControllerDelegate,UITextFieldDelegate {
    
    //TypeAction
    enum ActionType{
        case newProduct
        case editProduct
    }
    //Dinh nghia bien dung danh dau duong di
    var actionType:ActionType = .newProduct
    //UI
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profit: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var unit: UITextField!
    //Bien product dung de truyen tham so giua 2 man hinh
    var product:Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        name.keyboardType = .default
        profit.keyboardType = .numbersAndPunctuation
        unit.keyboardType = .default
        name.delegate = self
        profit.delegate = self
        unit.delegate = self
        if let product = product{
            actionType = .editProduct
            navigation.title = "Edit product"
            name.text = product.name
            profit.text = "\(product.profit)"
            unit.text = product.unit
            unit.isEnabled = false
        }
    }
    // Custom keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Kiểm tra nếu textField là profit (nhập số)
        if textField == profit {
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
            
            return true
        }
        
        // Cho phép thay đổi cho tất cả các trường hợp khác
        return true
    }

    
        // MARK: Dinh nghia ham uy quyen picker image
        // Ham uy quyen cua ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.originalImage] {
            // Ep kieu va doi anh
            productImage.image = img as? UIImage
        }
        dismiss(animated: true)
    }
    //ImagePicker
    @IBAction func imagePicker(_ sender: UITapGestureRecognizer) {
        // Tao doi tuong UIImagePickerController
        let imagePicker = UIImagePickerController()
        // Cau hinh cho doi tuong ImagePicker
        imagePicker.sourceType = .photoLibrary
        
        // Theo cach 2 uy quyen cho imagePicker truoc khi chuyen man hinh
        imagePicker.delegate = self
        
        // Chuyen man hinh sang man hinh picker
        present(imagePicker, animated : true)
    }
        // MARK: Dinh nghia ham uy quyen text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case name:
            name.resignFirstResponder()
        case profit:
            profit.resignFirstResponder()
        case unit:
            unit.resignFirstResponder()
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
        
        //TH1. Tu man hinh ProductTableView chuyen sang
        if let productTable = segue.destination as? ProductsTableViewController {
            switch actionType {
            case .newProduct:
                //tao doi tuong khi có các field khác rỗng
                if let name = name.text
                    ,let profit = profit.text
                    ,let unit = unit.text{
                    if !name.isEmpty && !profit.isEmpty && !unit.isEmpty{
                        product = Product(name: name, image: productImage.image, unit: unit, profit: Double(profit)!, quantity: 0, cost: 0)
                    }
                    
                }
            case .editProduct:
                if let name = name.text
                    ,let profit = profit.text
                    ,let unit = unit.text{
                    if !name.isEmpty && !profit.isEmpty && !unit.isEmpty{
                        //Cap nhat trang thai
                        actionType = .editProduct
                        product = Product(name: name, image: productImage.image, unit: product!.unit, profit: product!.profit, quantity: product!.quantity, cost: product!.cost)
                    }
                    
                }
            }
          
            
        }
        
    }
    
}
