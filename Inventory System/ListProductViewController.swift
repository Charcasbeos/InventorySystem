//
//  ListProductViewController.swift
//  Inventory System
//
//  Created by tran thu on 25/05/2024.
//

import UIKit

class ListProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    //Vi tri cell duoc tap
    var selectedIndexPath:Int = 0
    //Mang products
     var products = [Product]()
    var filteredProducts = [Product]()
    var isSearching = false
    //Khai bao doi tuong xu dung CSDL
    private let dao = Database()
    //UI
    @IBOutlet weak var navigation: UINavigationItem!

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        let _ = dao.deleteProductTable()
        searchbar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        //Doc du lieu product tren csdl
        dao.readProducts(products: &products)
        //Gan gia tri ban dau cho mang filter = products
        filteredProducts = products
        collectionView.reloadData()
        searchbar.placeholder = "Enter name product"
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
        
    //MARK: Collection view data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            // Return the number of sections
            return 1
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filteredProducts.count
    }
    //Tao cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "ProductCollectionViewCell"
        // Tao cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? ProductCollectionViewCell{
            //Lay phan tu thu i trong mang
            let product = filteredProducts[indexPath.row]
            //Do du lieu vao cell
            cell.cost.text = "\(String(format: "%.2f", product.cost))"
            cell.price.text = "\(String(format: "%.2f",product.cost * ((product.profit/100)+1)))"
            cell.quantity.text = "\(product.quantity) \(product.unit)"
            cell.profit.text = "\(String(format: "%.2f",product.profit)) %"
            cell.productName.text = product.name
            cell.productImage.image = product.image
            cell.parent = self
            cell.dao = dao
            cell.index = indexPath.row
            return cell
            
        }
        // Dung khi co loi nghiem trong
        fatalError("Khong the tao cell!")
    }
    
    // MARK: - Navigation
    //Chuyen sang man hinh update product
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if isSearching{
            // Hiển thị thông báo cảnh báo cho người dùng rằng họ đang trong quá trình tìm kiếm
                        let alert = UIAlertController(title: "Thông báo", message: "Bạn đang trong quá trình tìm kiếm. Bạn có muốn huỷ bỏ tìm kiếm và thêm mới không?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in
                            self.isSearching = false
                            self.filteredProducts = self.products
                            self.searchbar.text = ""
                            self.collectionView.reloadData()
                            // Tao doi tuong man hinh MealDetailController
                            if let updateProductController = self.storyboard!.instantiateViewController(withIdentifier: "updateProduct") as? UpdateProductController {
                                //Hien thi man hinh UpdateProductController
                                self.present(updateProductController, animated: true)
                                
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
        }
        else{
            // Tao doi tuong man hinh UpdateProductController
            if let updateProductController = self.storyboard!.instantiateViewController(withIdentifier: "updateProduct") as? UpdateProductController {
                //Hien thi man hinh UpdateProductController
                present(updateProductController, animated: true)
                
            }
        }
        
    }
    
   
    //Doc du lieu tu man hinh update product
    @IBAction func unwindAtListProductViewController(_ segue:UIStoryboardSegue){
        // Search bả quay ve trang thai ban dau
        searchbar.text=""
        //B1. Lay doi tuong man hinh updateProduct va lay bien product truyen ve
        if let updateProductController = segue.source as? UpdateProductController,
           let product = updateProductController.product{
            switch updateProductController.actionType {
            case .newProduct:
                //Ghi vao co so du lieu
                let _ = dao.insertProduct(product: product)
            case .editProduct:
                
                let _ = dao.updateProduct(product: product)
            }
            
        }
        //Reload lai du lieu moi cho collection view
        dao.readProducts(products: &products)
        filteredProducts = products
        collectionView.reloadData()
    }

}
