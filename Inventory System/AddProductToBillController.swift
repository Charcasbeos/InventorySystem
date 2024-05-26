//
//  AddProductToBillController.swift
//  Inventory System
//
//  Created by DaiTran on 20/5/24.
//

import UIKit

class AddProductToBillController: UITableViewController {

    var products:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let product1 = Product(name: "Test1", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        let product2 = Product(name: "Test2", unit: "unit2", profit: 10.0, quantity: 10, cost: 10)
        let product3 = Product(name: "Test3", unit: "unit1", profit: 10.0, quantity: 10, cost: 10)
        
        
        products.append(product1!)
        products.append(product2!)
        products.append(product3!)
        
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
            
            return cell
        }
        

        
//         Add gesture recognizer if not already added
//        if cell.onTapped == nil {
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editMeal))
//            cell.addGestureRecognizer(tapGestureRecognizer)
//            cell.onTapped = tapGestureRecognizer
//        }
        fatalError("Cell hasn't been created !!!")
        
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
