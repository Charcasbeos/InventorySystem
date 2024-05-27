//
//  AddProductToBillController.swift
//  Inventory System
//
//  Created by DaiTran on 20/5/24.
//

import UIKit
import OSLog

class AddProductToBillController: UIViewController, UITabBarControllerDelegate, UIProductStepperDelegate,UISearchBarDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    private let dao = Database()
    var products:[Product] = []
    var cart: [Product:Int] = [:]
    var filteredProducts:[Product] = []
    var isSearching = false
    
    let cartButton = UIButton(type: .custom)
    let draftAndSaveButton = UIDraftAndSaveButton()
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //custom UI for cart button
        cartButton.setImage(UIImage(named: "shopping-cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigation.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        // Register footer view
        collectionView.register(UIDraftAndSaveButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UIDraftAndSaveButton.reuseIdentifier)
        
        // Add draftAndSaveButton as a subview to the footview
        let footerView = UIView()
        footerView.addSubview(draftAndSaveButton)
        footerView.frame.size.height = 50
        collectionView.insertSubview(footerView, at: 0)
        
        draftAndSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            draftAndSaveButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            draftAndSaveButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            draftAndSaveButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            draftAndSaveButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            draftAndSaveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let _ = addSampleProducts()
        
        updateCartBadge()
        
        //set default data for filtered products array
        filteredProducts = products
        collectionView.reloadData()
        searchBar.placeholder = "Enter product's name"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyBoard))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Hiển thị tất cả sản phẩm nếu không có từ khóa tìm kiếm
            filteredProducts = products
            isSearching = false
            print("empty")
        }
        else {
            isSearching = true
            // Lọc danh sách sản phẩm theo từ khóa tìm kiếm
            filteredProducts = products.filter{product in
                return product.name.lowercased().contains(searchText.lowercased()) }
            print("has")
            
            
        }
        
        // Cập nhật CollectionView
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel btn")
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredProducts = products
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
    }
        
    
    
    @objc func dissmisKeyBoard(){
        view.endEditing(true)
    }
    
    //MARK: Collection view data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseCell = "ProductOfBillCollectionViewCell"
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? ProductOfBillCollectionViewCell{
            
            let product = filteredProducts[indexPath.row]
            cell.productName.text = product.name
            cell.productPrice.text = "\(String(format: "%.2f",product.cost * ((product.profit/100)+1)))"
            cell.productQuantity.text = "\(product.quantity) \(product.unit)"
            cell.productImage.image = UIImage(named: "shopping-cart")
            
            
            // Set delegate for product stepper
            cell.stepper.delegate = self
            cell.stepper.tag = indexPath.row
            
            
            return cell
        }
        
        fatalError("Cell hasn't been created !!!")
    }
    

    // MARK: - Collection view delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UIDraftAndSaveButton.reuseIdentifier, for: indexPath) as! UIDraftAndSaveButton
            return footerView
        }
        fatalError("Unexpected element kind")
    }
    //MARK: Add sample products
    func addSampleProducts(){
        
        
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
