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
    var billFromBillCell:Bill?
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var totalAmountText: UILabel!
    
    
    @IBAction func doneConfirmation(_ sender: UIButton) {
        //Kiem tra customer có nhập thì lưu, chua co thi tao va cap nhat accumula
        if let customerPhone = customerPhone{
            if let phone = customerPhone.text, let name = customerName.text{
                for customer in customers {
                    if customer.phoneNumber.elementsEqual(phone){
                        check = true
                    }
                    
                }
                if check == false{
                    if let customerNew = Customer(name: customerName.text!, phoneNumber: customerPhone.text!, accumulatedMoney: 0){
                        customerID =  dao.insertCustomer(customer: customerNew)}
                }
                print("\(totalAmount)")
                dao.updateCustomer(customerID: customerID,  money: totalAmount)
                // Tạo một đối tượng DateFormatter
                let dateFormatter = DateFormatter()
                
                // Đặt định dạng cho DateFormatter
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                // Chuyển đổi Date thành String
                let dateStr = dateFormatter.string(from: Date())

                let billId = dao.insertBill(bill: Bill(customerID: Int32(customerID), status: 1, date: dateStr))
                for (product,quantity) in cart! {
                    let billDetail = BillDetail(billID:Int32(billId),productID: product.id, productName: product.name, productProfit: product.profit, productCost: product.cost, quantity: quantity)
                    dao.insertBillDetail(billDetail: billDetail)
                }
                dao.decreaseProductQuantity(products: cart!)
            }
            
        }
        
        if let home = self.storyboard!.instantiateViewController(withIdentifier: "Home") as? HomeController
        {
            home.modalPresentationStyle = .fullScreen
            present(home, animated: true)
        }
        
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
        
        //Kiem tra co phai di tu man hinh ListBill
        if let billFromBillCell = billFromBillCell{
            var customerPhone = "unknown"
            var customerName = "unknown"
            
            if let customer = dao.readCustomerByID(customer_id: Int(billFromBillCell.customerID)){
                customerName = customer.name
                customerPhone = customer.phoneNumber
            }
            // Lay thong tin cua billDetail
            var listBillDetailById = [BillDetail]()
            dao.listBillDetailByBillId(billId: Int(billFromBillCell.id), listBillDetailById: &listBillDetailById)
            var cartRs: [Product:Int] = [:]
            for item in listBillDetailById{
                let unit = dao.readProductByID(id: Int(item.productID))!.unit
                var product = Product(id: item.productID,name: item.productName, unit:unit , profit: item.productProfit, quantity: 0, cost: item.productCost)
              
                cartRs[product!] = item.quantity
                print("\(cartRs.count)")
                
            }
           
            cart! = cartRs
            print("cart count = \(cart!.count)")
            self.customerName.text = customerName
            self.customerPhone.text = customerPhone
            editButton.isHidden = true
        }
            
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
        dismiss(animated: true)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
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
