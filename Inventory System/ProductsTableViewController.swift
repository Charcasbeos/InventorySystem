//
//  StorageTableViewController.swift
//  Inventory System
//
//  Created by tran thu on 20/05/2024.
//

import UIKit

class ProductsTableViewController: UITableViewController, UITabBarControllerDelegate{
    //Vi tri cell duoc tap
    private var selectedIndexPath:IndexPath?
    //Mang products
    private var products = [Product]()
    //Khai bao doi tuong xu dung CSDL
    private let dao = Database()
    
    //UI
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var delete: UIBarButtonItem!
    
    //Func
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.setRightBarButton(delete, animated: true)
        navigation.rightBarButtonItem = editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    //Tao cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "ProductCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? ProductCell{
            //Lay phan tu thu i trong mang
            let product = products[indexPath.row]
            //Do du lieu vao cell
            cell.cost.text = "\(0)"
            cell.price.text = "\(0)"
            cell.quantity.text = "\(0) \(product.unit)"
            cell.profit.text = "\(product.profit)"
            cell.productName.text = product.name
            cell.productImage.image = product.image
            
            
            return cell
        }
        // Dung khi co loi nghiem trong
        fatalError("Khong the tao cell!")
        
    }
    
    //Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           //Xoa meal tu data source
           products.remove(at: indexPath.row)
            //Delete the row from the data source
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
   }
    
     // MARK: - Navigation
    //Bat su kien cho cell theo cach 3 se chuyen sang man hinh Import Export
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tao doi tuong man hinh MealDetailController
        if let importExportTable = self.storyboard!.instantiateViewController(withIdentifier: "ImportExportTable") as? ImportExportTableViewController {
            //Dua du lieu can truyen vao bien product cua man hinh update product
            importExportTable.product = products[indexPath.row]
           
            //Luu vi tri cell duoc tap
            selectedIndexPath = indexPath
            
            //Hien thi man hinh meal detail controller
            present(importExportTable, animated: true)
        }
            
    }
    
    
    //Chuyen sang man hinh update product
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh MealDetailController
        if let updateProductController = self.storyboard!.instantiateViewController(withIdentifier: "updateProduct") as? UpdateProductController {
            //Hien thi man hinh meal detail controller
            present(updateProductController, animated: true)
            
        }
        
    }
    
    //Doc du lieu tu man hinh update product
    @IBAction func unwindFromUpdateProductsTable(_ segue:UIStoryboardSegue){
        
        //B1. Lay doi tuong man hinh updateProduct va lay bien product truyen ve
        if let updateProductController = segue.source as? UpdateProductController,
           let product = updateProductController.product{
            switch updateProductController.actionType {
            case .newProduct:
                
                product.id = products.count + 1
                //B2. Them product moi vao tableView
                //B2.1 Them vao data source
                products.append(product)
                
                //B2.1 Them dong moi vao table view
                let newIndexPath = IndexPath(row: products.count - 1, section: 0)
                
                tableView.insertRows(at: [newIndexPath], with: .left)
                
                //Ghi vap co so du lieu
                let _ = dao.insertProduct(product: product)
                
            case .editProduct:
                if let indexPath = selectedIndexPath{
                    // update data source
                    products[indexPath.row] = product
                    //Reload lai du lieu moi cho table view
                    tableView.reloadRows(at: [indexPath], with:.left)
                }
            }
            
        }
    }
}
