//
//  CustomerTableViewController.swift
//  Inventory System
//
//  Created by Do Ngoc Hieu on 21/5/24.
//

import UIKit

class CustomerTableViewController: UITableViewController {
    //MARK : properties
    private var customers = [Customer]()
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var delete: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Dinh nghia nut xoa
        delete.target = self
        delete.action = #selector(trashButtonTapped)
        
        
        
        //tao du lieu gia cho table view
        if let custome = Customer(name: "Do Ngoc Hieu", phoneNumber: "0384946973", accumulatedMoney: 12000)
        {
            customers.append(custome)
        }
        if let custome = Customer(name: "Do Ngoc Hi", phoneNumber: "0384946973", accumulatedMoney: 12000)
        {
            customers.append(custome)
        }
        if let custome = Customer(name: "Do Ngoc", phoneNumber: "0384946973", accumulatedMoney: 12000)
        {
            customers.append(custome)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //
    @objc func trashButtonTapped(){
        self.isEditing = !self.isEditing
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "CellCustomer"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? CellCustomer {
            //Lay phan tu thu i trong mang
            let customer = customers[indexPath.row]
            //do du lieu vao cell
            cell.nameCustomer.text = customer.name
            cell.phoneCustomer.text = customer.phoneNumber
            cell.accumulatedMoneyCustomer.text = String(customer.accumulatedMoney)
            
         
          
            
            return cell
        }
        
        fatalError("Khong the tao bang")
    }
    @IBAction func unwindFromAddCustomer (_ seque:UIStoryboardSegue){
        if let customerController = seque.source as? AddCustomController, let customer = customerController.customer {
            // them custom moi vao tableView
            // them vao data source
            customers.append(customer)
            // them dong moi vao tableView
            let newIndexPath = IndexPath(row: customers.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .left)        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
     //Nut thoat
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
     // Override to support editing the table view.
    //Xu ly hanh dong xoa
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
         //Xoa phan tu ra khoi du lieu
         customers.remove(at: indexPath.row)
         //Xoa hang khoi bang
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
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
