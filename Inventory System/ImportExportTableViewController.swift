//
//  ImportExportTableViewController.swift
//  Inventory System
//
//  Created by tran thu on 23/05/2024.
//

import UIKit

class ImportExportTableViewController: UITableViewController {
    //Vi tri cell duoc tap
    private var selectedIndexPath:IndexPath?
    //Mang products
    private var import_exports = [ImportExport]()
    //Khai bao doi tuong xu dung CSDL
    private let dao = Database()
    //Bien product dung de truyen tham so giua man hinh listProductViewController va man hinh nay
        var product:Product?
    var productId = 0
    //UI
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = "\(product!.name) - \(product!.profit)%"
        if let product = product{
            productId = Int(product.id)
            dao.readImportExportsByProductID(productID: Int(product.id), importexports: &import_exports)
        }
        
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
        return import_exports.count
    }

    //Tao cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "ImportExportCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? ImportExportCell{
            //Lay phan tu thu i trong mang
            let import_export = import_exports[indexPath.row]
            //Lay date
            let date = import_export.date
            // Định dạng ngày và giờ
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Định dạng thời gian
            let formattedDate = dateFormatter.string(from: date)
            
            //Do du lieu vao cell
            cell.dateImportExport.text = "\(formattedDate)"
            cell.quantity.text = "\(import_export.quantity)"
            cell.cost.text = "\(import_export.cost)"
            return cell
        }
        // Dung khi co loi nghiem trong
        fatalError("Khong the tao cell!")
        
    }

    
    // MARK: - Navigation
     //Chuyen sang man hinh updateImportExport
     @IBAction func addItem(_ sender: UIBarButtonItem) {
         // Tao doi tuong man hinh UpdateController
         if let updateImportExport = self.storyboard!.instantiateViewController(withIdentifier: "UpdateImportExport") as? UpdateImportExportController {
             updateImportExport.product = product
             //Hien thi man hinh UpdateController
             present(updateImportExport, animated: true)
             
         }
         
     }
   
    //Chuyen sang man hinh update product
    @IBAction func editProduct(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh UpdateProductController
        if let updateProduct = self.storyboard!.instantiateViewController(withIdentifier: "updateProduct") as? UpdateProductController {
            updateProduct.product = product
            updateProduct.actionType = .editProduct
            //Hien thi man hinh UpdateProductController
            present(updateProduct, animated: true)
            
        }
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
    }
    

    //Doc du lieu tu man hinh update product
    @IBAction func unwindAtImportExportTableViewController(_ segue:UIStoryboardSegue){
        
        //B1. Lay doi tuong man hinh updateProduct va lay bien product truyen ve
        if let updateImportExport = segue.source as? UpdateImportExportController,
           let import_export = updateImportExport.import_export{
//            
//            //B2. Them product moi vao tableView
//            //B2.1 Them vao data source
//            import_exports.append(import_export)
//            
//            //B2.1 Them dong moi vao table view
//            let newIndexPath = IndexPath(row: import_exports.count - 1, section: 0)
//            
//            tableView.insertRows(at: [newIndexPath], with: .left)
            
            //Ghi vap co so du lieu
            let insert = dao.insertImportExport(importexport: import_export)
            if insert{
                //Lay product tu productID
                if let product = dao.readProductByID(id: productId){
                    //Lay quantity hien tai cua Product
                    var quantity = product.quantity
                    //Lay cost hien tai cua product duoc tinh theo pp la trung binh cong
                    var cost = product.cost
                    //Tong san pham
                    let totalQuantity = quantity + import_export.quantity
                    //So luong cu * gia cu
                    let old = cost * Double(quantity)
                    //So luong moi * gia moi
                    let new = Double(import_export.quantity) * import_export.cost
                    //Tinh lai gia cost cho san pham
                    cost = (old + new) / Double(totalQuantity)
                    //Tong san pham cua san pham sau khi them importexport
                    quantity = totalQuantity
                    //Gia moi sau khi cap nhat gia cost (Hien thi ben phuc)
                    let price = cost * (product.profit+100)/100
                    //Update lai gia cost vaf so luong ton kho cho san pham
                    if let productUpdate = Product(id:product.id ,name: product.name,image: product.image, unit: product.unit, profit: product.profit, quantity: quantity, cost: cost){
                        if dao.updateProduct(product: productUpdate){
                            print("Cap nhat lai gia cost, so luong, gia price cho san pham \(productUpdate.id) q: \(productUpdate.quantity)")
                        }
                        else{
                            print("update fail")
                        }
                    }
                }
            }
            dao.readImportExportsByProductID(productID:productId , importexports: &import_exports)
            tableView.reloadData()
        }
    }
}
