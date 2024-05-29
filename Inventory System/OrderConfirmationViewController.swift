//
//  OrderConfirmationViewController.swift
//  Inventory System
//
//  Created by DaiTran on 28/5/24.
//

import UIKit
import OSLog

class OrderConfirmationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    //Properties
    let editButton = UIButton(type: .custom)
    var cart: [Product:Int]? = [:]
    let dao: Database = Database()
    var customers:[Customer] = []
    var customerID = -1
    var check = false
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var totalAmountText: UILabel!
    
    
    @IBAction func doneConfirmation(_ sender: UIButton) {
        //Kiem tra customer có nhập thì lưu, chua co thi tao va cap nhat accumula
        if let customerPhone = customerPhone{
            if let phone = customerPhone.text , !phone.isEmpty{
                for customer in customers {
                    if customer.phoneNumber.elementsEqual(phone){
                        check = true
                    }
                    
                }
                if check == false{
                    if let customerNew = Customer(name: customerName.text!, phoneNumber: phone, accumulatedMoney: 0){
                        customerID =  dao.insertCustomer(customer: customerNew)}
                }
                print("\(totalAmount)")
                dao.updateCustomer(customerID: customerID,  money: totalAmount)
                
            }
        }
        
        dao.updateSatusBill(billID: billId, status: 1,customerId: customerID)
        
    }
    var totalAmount:Double = 0
    var billId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Read customers from db
        dao.readAllCustomer(customers: &customers)
        for (product, quantity) in cart! {
            os_log("Product: %@, Quantity: %d", product.name, quantity)
        }
        //custom UI for cart button
        editButton.setImage(UIImage(named: "edit-30"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigation.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //calculate the sum of cart product's price
        for (product, quantity) in cart! {
            // set value for total amount label
            totalAmount += product.cost * ((product.profit / 100) + 1) * Double(quantity)
        }
        
            
        customerPhone.keyboardType = .numberPad
        customerPhone.addTarget(self, action: #selector(customerPhoneEditingChanged), for: .editingChanged)
        
        print("bill id: \(billId)")
        
    }
    @objc func customerPhoneEditingChanged(){
      
        if customerPhone.state.isEmpty{
            customerName.text = ""
        }
        
        if let phone = customerPhone.text {
            for customer in customers {
                if customer.phoneNumber.elementsEqual(phone){
                    os_log("Order: \(customer.name)")
                    customerName.text = customer.name
                    customerID = Int(customer.id)
                }
            }
          
        }
        
    }
    
    @objc func editButtonTapped(){
        os_log("editButtonTapped")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func doneButtonTapped() {
        
        
    }
    
    
    
    //MARK: Table view controller
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "UIOrderComfirmationViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? UIOrderComfirmationViewCell{
            
            let product = Array(cart!.keys)[indexPath.row]
            let quantity = cart![product] ?? 0
            
            cell.productName.text = product.name
            cell.productPrice.text = "\(String(format: "%.2f",product.cost * ((product.profit/100)+1)))"
            cell.productQuantity.text = "\(quantity) \(product.unit)"
          
            totalAmountText.text =  "\(String(format: "%.2f",totalAmount)) đ"
            return cell
        }
        fatalError("khong the tao cell")
    }
    
    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Customize this value as needed
    }
      
    
}
