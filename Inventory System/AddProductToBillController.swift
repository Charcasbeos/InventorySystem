//
//  AddProductToBillController.swift
//  Inventory System
//
//  Created by DaiTran on 20/5/24.
//

import UIKit
import OSLog

class AddProductToBillController: UITableViewController, UITabBarControllerDelegate, UIProductStepperDelegate {

    

    var products:[Product] = []
    var cart: [Product:Int] = [:]
    
    
    @IBOutlet weak var navigation: UINavigationItem!
    let cartButton = UIButton(type: .custom)    
    let draftAndSaveButton = UIDraftAndSaveButton()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //custom UI for cart button
        cartButton.setImage(UIImage(named: "shopping-cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        
        
        
        navigation.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        
        // Add draftAndSaveButton as a subview to the footview
        let footerView = UIView()
        footerView.addSubview(draftAndSaveButton)
        
        
        
        draftAndSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            draftAndSaveButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            draftAndSaveButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            draftAndSaveButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            draftAndSaveButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            draftAndSaveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tableView.tableFooterView = footerView
        footerView.frame.size.height = 50
        
        
        
        
        let product1 = Product(name: "Test1", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product2 = Product(name: "Test2", unit: "unit2", profit: 10.0, quantity: 10, cost: 10)
        let product3 = Product(name: "Test3", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product4 = Product(name: "Test1", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product5 = Product(name: "Test2", unit: "unit2", profit: 10.0, quantity: 10, cost: 10)
        let product6 = Product(name: "Test3", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product7 = Product(name: "Test1", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product8 = Product(name: "Test2", unit: "unit2", profit: 10.0, quantity: 10, cost: 10)
        let product9 = Product(name: "Test3", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        
        
        
        products.append(product1!)
        products.append(product2!)
        products.append(product3!)
        products.append(product4!)
        products.append(product5!)
        products.append(product6!)
        products.append(product7!)
        products.append(product8!)
        products.append(product9!)
        
        
        updateCartBadge()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyBoard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dissmisKeyBoard(){
        view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "ProductOfBillCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? ProductOfBillCell{
            
            let product = products[indexPath.row]
            cell.productName.text = product.name
            cell.productPrice.text = product.unit
            
            // Set delegate for product stepper
            cell.stepper.delegate = self
            cell.stepper.tag = indexPath.row
            
            
            return cell
        }
        
        fatalError("Cell hasn't been created !!!")
        
    }
    
    //MARK: Add product to cart
    func addToCart(product: Product,quantity: Int){
        cart[product] = quantity
        updateCartBadge()
    }
    
    //MARK: update car badge
    func updateCartBadge() {
        
        cartButton.subviews.forEach { subview in
            if subview.tag == 99 { subview.removeFromSuperview() }
        }
        
        let totalProducts = getTotalProductsInCart()
        
        if totalProducts > 0 {
            let badgeLabel = UILabel()
            badgeLabel.text = "\(totalProducts)"
            badgeLabel.textColor = .white
            badgeLabel.backgroundColor = .red
            badgeLabel.textAlignment = .center
            badgeLabel.font = UIFont.systemFont(ofSize: 12)
            badgeLabel.layer.cornerRadius = 10
            badgeLabel.clipsToBounds = true
            badgeLabel.tag = 99
            
            let badgeSize: CGFloat = 20
            badgeLabel.frame = CGRect(x: cartButton.frame.width - badgeSize / 2,
                                      y: -badgeSize / 2,
                                      width: badgeSize,
                                      height: badgeSize)
            
            cartButton.addSubview(badgeLabel)
        }
    }
        
    func getTotalProductsInCart() -> Int {
        // Return the actual total products count from your cart data source
        return cart.values.reduce(0, +)
    }

    func productStepper(_ stepper: UIProductStepper, didChangeQuantity quantity: Int) {
        //The tag property is used to store the index of the product in the products array.
        let productIndex = stepper.tag
        let product = products[productIndex]
        
        addToCart(product: product, quantity: quantity)
        
        
    }
    
    
    @objc func cartButtonTapped(){
        os_log("Cart Button Tapped")
    }
    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
