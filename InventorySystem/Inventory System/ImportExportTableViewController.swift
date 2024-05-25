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
    //Bien product dung de truyen tham so giua man hinh productTable va man hinh nay
        var product:Product?
    //UI
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = "\(product!.name) - \(product!.profit)%"
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
            //Hien thi man hinh UpdateProductController
            present(updateProduct, animated: true)
            
        }
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    

    //Doc du lieu tu man hinh update product
    @IBAction func unwindFromUpdateImportExport(_ segue:UIStoryboardSegue){
        
        //B1. Lay doi tuong man hinh updateProduct va lay bien product truyen ve
        if let updateImportExport = segue.source as? UpdateImportExportController,
           let import_export = updateImportExport.import_export{
            
            //B2. Them product moi vao tableView
            //B2.1 Them vao data source
            import_exports.append(import_export)
            
            //B2.1 Them dong moi vao table view
            let newIndexPath = IndexPath(row: import_exports.count - 1, section: 0)
            
            tableView.insertRows(at: [newIndexPath], with: .left)
            
            //Ghi vap co so du lieu
            let _ = dao.insertImportExport(importexport: import_export)
             
        }
    }
}
