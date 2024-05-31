//
//  AddProductToBillController.swift
//  Inventory System
//
//  Created by DaiTran on 20/5/24.
//

import UIKit
import OSLog

class AddProductToBillController: UIViewController, UITabBarControllerDelegate, UIProductStepperDelegate,UISearchBarDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let orderConfirmationStoryBoardId = "showOrderConfirmation"
    private let dao = Database()
    var products:[Product] = []
    var cart: [Product:Int] = [:]
    var filteredProducts:[Product] = []
    var isSearching = false
    var fromConfirm = false
    
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
   
        
        draftAndSaveButton.frame.size = CGSize(width: 50, height: 50)
        view.addSubview(draftAndSaveButton)
        
        
        
        draftAndSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Assign closures
        draftAndSaveButton.onDraftButtonTapped = { [weak self] in
           
        }
        draftAndSaveButton.onSaveButtonTapped = { [weak self] in
            self?.handleSaveButtonTapped()
        }
        
        
        NSLayoutConstraint.activate([
            draftAndSaveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            draftAndSaveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            draftAndSaveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            draftAndSaveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            draftAndSaveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        

        
        
        
        //fetch data from db
        let _ = dao.readProducts(products: &products)
        
        updateCartBadge()
        
        //set default data for filtered products array
        filteredProducts = products
        collectionView.reloadData()
        searchBar.placeholder = "Enter product's name"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyBoard))
        view.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        if cart.count != 0 {
            // Tạo hộp thoại cảnh báo
            let alert = UIAlertController(title: "Confirm back", message: "Are you sure you want to back ?", preferredStyle: .alert)
            
            // Thêm hành động cho nút "Xoá"
            alert.addAction(UIAlertAction(title: "Back", style: .destructive, handler: { action in
                self.dismiss(animated: true)
            }))
            
            // Thêm hành động cho nút "Huỷ"
            alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
            
            // Hiển thị hộp thoại cảnh báo
            present(alert, animated: true, completion: nil)
            
        }
        else{
            dismiss(animated: true)
        }
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
            cell.productImage.image = product.image
            
            // Set delegate for product stepper
            cell.stepper.setProgrammaticValue(cart[product] ?? 0)
            cell.stepper.tag = indexPath.row
            cell.stepper.delegate = self
            
            
            
            return cell
        }
        
        fatalError("Cell hasn't been created !!!")
    }
    
    
    // MARK: - Collection view delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UIDraftAndSaveButton.reuseIdentifier, for: indexPath) as! UIDraftAndSaveButton
            // Assign closures
            footerView.onDraftButtonTapped = { [weak self] in
                self?.handleDraftButtonTapped()
            }
            footerView.onSaveButtonTapped = { [weak self] in
                self?.handleSaveButtonTapped()
            }
            
            print("Assigned onDraftButtonTapped and onSaveButtonTapped closures to footer view")
            return footerView
        }
        fatalError("Unexpected element kind")
    }
     */
    
    
    //MARK: Add sample products
    func addSampleProducts(){
        
        
        let product1 = Product(name: "Test1", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product2 = Product(name: "Test2", unit: "unit2", profit: 10.0, quantity: 20, cost: 10)
        let product3 = Product(name: "Test3", unit: "unit1", profit: 10.0, quantity: 30, cost: 10)
        let product4 = Product(name: "Test4", unit: "unit1", profit: 10.0, quantity: 40, cost: 10)
        let product5 = Product(name: "Test5", unit: "unit2", profit: 10.0, quantity: 50, cost: 10)
        let product6 = Product(name: "Test6", unit: "unit1", profit: 10.0, quantity: 60, cost: 10)
        let product7 = Product(name: "Test7", unit: "unit1", profit: 10.0, quantity: 70, cost: 10)
        let product8 = Product(name: "Test8", unit: "unit2", profit: 10.0, quantity: 80, cost: 10)
        let product9 = Product(name: "Test9", unit: "unit1", profit: 10.0, quantity: 90, cost: 10)
        
        
        
        products.append(product1!)
        products.append(product2!)
        products.append(product3!)
        products.append(product4!)
        products.append(product5!)
        products.append(product6!)
        products.append(product7!)
        products.append(product8!)
        products.append(product9!)
//        
//        for product in products {
//            dao.insertProduct(product: product)
//        }
        
        
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
        
                        
        // Check if the new quantity exceeds the available quantity in storage
        if quantity <= product.quantity {
            if cart[product] != quantity {
                addToCart(product: product, quantity: quantity)
                updateCartBadge()
            }
        } else {
            // Reset stepper value to the maximum available quantity
            stepper.quantityValue = product.quantity
            showAlertForExceedingQuantity(product: product)
        }
        os_log("cart: \(self.cart)")
    }
    func showAlertForExceedingQuantity(product: Product) {
        let alert = UIAlertController(
            title: "Quantity Exceeded",
            message: "You cannot add more than \(product.quantity) \(product.unit) of \(product.name) to the cart.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertForExceedingEmptyCart() {
        let alert = UIAlertController(
            title: "Empty Cart",
            message: "You need to add at least 1 product to the cart.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cartButtonTapped(){
        os_log("Cart Button Tapped")
    }
    
    
    
    // Handle Save Button Tap
    func handleSaveButtonTapped() {
        print("Save button tapped in controller")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let orderConfirmationVC = storyboard.instantiateViewController(withIdentifier: "showOrderConfirmation") as? OrderConfirmationViewController {
            
            // Collect the keys for items to remove
            let itemsToRemove = cart.filter { $0.value == 0 }.map { $0.key }
            
            // Remove the items from the cart
            for key in itemsToRemove {
                cart.removeValue(forKey: key)
            }
            
            if cart.isEmpty{
                showAlertForExceedingEmptyCart()
            }
            // Tạo một đối tượng DateFormatter
            let dateFormatter = DateFormatter()
            
            // Đặt định dạng cho DateFormatter
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Chuyển đổi Date thành String
            let dateString = dateFormatter.string(from: Date())
            
            orderConfirmationVC.cart = cart
            orderConfirmationVC.modalPresentationStyle = .fullScreen
            present(orderConfirmationVC, animated: true, completion: nil)
            
            
        }
    }
    // Unwind segue action
    @IBAction func unwindToAddProductToBillController(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? OrderConfirmationViewController {
            self.cart = sourceVC.cart!
            os_log("cart: \(self.cart)")
            fromConfirm = true
            updateCartBadge()
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderConfirmation" {
            if let destinationVC = segue.destination as? OrderConfirmationViewController {
                destinationVC.cart = cart
            }
        }
    }
    
    */
    
    
}
