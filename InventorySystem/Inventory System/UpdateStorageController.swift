////
////  UpdateStorageController.swift
////  Inventory System
////
////  Created by tran thu on 21/05/2024.
////
//
//import UIKit
//
//class UpdateStorageController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITabBarControllerDelegate,UITextFieldDelegate {
//
//    // MARK: Properties
//    @IBOutlet weak var navigation: UINavigationItem!
//    @IBOutlet weak var productImage: UIImageView!
//    // Textfields
//    @IBOutlet weak var productName: UITextField!
//    @IBOutlet weak var cost: UITextField!
//    @IBOutlet weak var profit: UITextField!
//    @IBOutlet weak var quantity: UITextField!
//    @IBOutlet weak var price: UITextField!
//    @IBOutlet weak var unit: UITextField!
//    @IBAction func stepper(_ sender: UIStepper) {
//        
//    }
//    //Bien product dung de truyen tham so giua 2 man hinh
//    var product:Product?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        productName.delegate = self
//        cost.delegate = self
//        profit.delegate = self
//        quantity.delegate = self
//        price.delegate = self
//        unit.delegate = self
//    }
//    
//    
//    @IBAction func imagePicker(_ sender: UITapGestureRecognizer) {
//       
//        // Tao doi tuong UIImagePickerController
//        let imagePicker = UIImagePickerController()
//        // Cau hinh cho doi tuong ImagePicker
//        imagePicker.sourceType = .photoLibrary
//        
//        // Theo cach 2 uy quyen cho imagePicker truoc khi chuyen man hinh
//        imagePicker.delegate = self
//        
//        // Chuyen man hinh sang man hinh picker
//        present(imagePicker, animated : true)
//        
//    }
//    // MARK: Dinh nghia ham uy quyen text field
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case productName:
//            productName.resignFirstResponder()
//        case cost:
//            cost.resignFirstResponder()
//        case profit:
//            profit.resignFirstResponder()
//        case price:
//            price.resignFirstResponder()
//        case quantity:
//            quantity.resignFirstResponder()
//        case unit:
//            unit.resignFirstResponder()
//        default:
//            print("Error!")
//        }        
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//
//    }
//    // MARK: Dinh nghia ham uy quyen picker image
//    // Ham uy quyen cua ImagePickerController
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        if let img = info[.originalImage] {
//            // Ep kieu va doi anh
//            productImage.image = img as? UIImage
//        }
//        dismiss(animated: true)
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//
//    */
//
//    
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        print("cancel called")
//        dismiss(animated: true, completion: nil)
//    }
//    @IBAction func save(_ sender: UIBarButtonItem) {
//        
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == price{
//            let p:Int = Int(cost.text!)!*(1+(Int(profit.text!)!/100))
//            price.text = String(p)
//        }
//    }
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        //Tao doi tuong new meal de truyen sang man hinh A
////        let name = productName.text ?? ""
////        let unit = unit.text ?? ""
////        //Unwrap duoc vi text luon co du lieu
////        let cost = Int(cost.text!)
////        let profit = Int(profit.text!)
////        let price = Int(price.text!)
////        let quantity = Int(quantity.text!)
////
////        product = Product(name: name, image: productImage.image, unit:unit, cost: cost!, profit: profit!, price: price!, quantity: quantity!)
////        
////    }
//}
