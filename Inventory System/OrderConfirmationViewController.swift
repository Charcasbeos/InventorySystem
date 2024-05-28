//
//  OrderConfirmationViewController.swift
//  Inventory System
//
//  Created by DaiTran on 28/5/24.
//

import UIKit
import OSLog

class OrderConfirmationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Properties
    let editButton = UIButton(type: .custom)
    var cart: [Product:Int]? = [:]
    
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: UINavigationItem!
    
    
    
    var doneButton = UIButton()
    let items = [
            ["name": "Thịt bò cube nhập khẩu", "pricePerKg": "250,000 đ/Kg", "discount": "Giảm giá: 10%", "total": "2,500,000 đ"],
            ["name": "Thịt bò cube nhập khẩu", "pricePerKg": "250,000 đ/Kg", "discount": "Giảm giá: 10%", "total": "2,500,000 đ"],
            ["name": "Thịt bò cube nhập khẩu", "pricePerKg": "250,000 đ/Kg", "discount": "Giảm giá: 10%", "total": "2,500,000 đ"],
            ["name": "Thịt bò cube nhập khẩu", "pricePerKg": "250,000 đ/Kg", "discount": "Giảm giá: 10%", "total": "2,500,000 đ"]
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cart = cart{
            os_log("Cart data: \(cart)")
        }
        
        //custom UI for cart button
        editButton.setImage(UIImage(named: "edit-30"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigation.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        setupDoneButton()
        
    }
    
    @objc func editButtonTapped(){
        os_log("editButtonTapped")
        dismiss(animated: true, completion: nil)
    }
    
    func setupDoneButton() {
        doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        view.addSubview(doneButton)
        
        // Set constraints for the button
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func doneButtonTapped() {
        // Handle the button tap action here
        print("Done button tapped")
        performSegue(withIdentifier: "unwindToAddProductToBillController", sender: self)
    }
    
    
    
    //MARK: Table view controller
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "UIOrderComfirmationViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? UIOrderComfirmationViewCell{
            
            let item = items[indexPath.row]
            cell.productName.text = item["name"]
            cell.productPrice.text = "222222 d"
            cell.productQuantity.text = "2222 pcs"
            
            return cell
        }
        fatalError("khong the tao cell")
    }
    
    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Customize this value as needed
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
