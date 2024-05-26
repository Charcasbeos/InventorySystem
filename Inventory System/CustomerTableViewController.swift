//
//  CustomerTableViewController.swift
//  Inventory System
//
//  Created by Do Ngoc Hieu on 21/5/24.
//

import UIKit

class CustomerTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    //MARK : properties
    private var customers = [Customer]()
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var delete: UIBarButtonItem!
    
    // Lưu selected indexPath của cell
    private var selectedIndexPath:IndexPath?
    
    // Định nghĩa đối tượng truy vấn csdl
    private let dao = Database()
    // Định nghĩa kiểu dữ liệu Enum để đánh dấu đường đi
    enum NavihationType {
        case newCustomer
        case editCustomer
    }
    // Định nghĩa biến dùng để đánh dấu đường đi
    var navigationType:NavihationType = .newCustomer

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Dinh nghia nut xoa
        delete.target = self
        delete.action = #selector(trashButtonTapped)
        
        
        
        //tao du lieu gia cho table view
//        if let custome = Customer(name: "Do Ngoc Hieu", phoneNumber: "0384946973", accumulatedMoney: 12000)
//        {
//            customers.append(custome)
//            // Ghi customer vua tao vao CSDL
//            let _ = dao.insertCustomer(customer: custome)
//        }
        
        // Doc du lieu tu CSDL (Neu co) va dua vao datasource
        dao.readAllCustomer(customers: &customers)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //
    @objc func trashButtonTapped(){
        //Set neu nhan thi se chuyen true thanh fasle , fasle thanh true
        self.isEditing = !self.isEditing
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Tra ve section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Tra ve so luong
        return customers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tham số nhận định danh
        let reuseCell = "CellCustomer"
         //Tai su dung cell
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
    
    @IBAction func unwindFromAddCustomer (_ segue:UIStoryboardSegue){
        // Lay doi tuong man hinh AddCustomController
        if let customDetail = segue.source as? AddCustomController {
            // Lay customer moi tao tu B ve A
            if let customer = customDetail.customer {
                // Lay customer moi tao tu B ve A
                switch navigationType {
                case .newCustomer:
                    //Them khach hang vao tableView
                    // 1. Them customer moi vao datasource
                    customers.insert(customer, at: 0)
                    // 2. Insert customer moi vao tableView
                    let newIndexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    
                    // Ghi customer vua tao vao CSDL
                    let _ = dao.insertCustomer(customer: customer)
                    
                    
                case .editCustomer:
                    //lay vi tri duoc danh dau neu co
                    if let indexPathOld = selectedIndexPath {
                        //Lay lai id cua customer cu dua vao meal moi
                        customer.id = customers[indexPathOld.row].id
                        
                        // Cap nhat customer vao datasource
                        customers[indexPathOld.row] = customer
                        // Cap nhat customer trong tableView
                        tableView.reloadRows(at: [indexPathOld], with: .left)
        
                        //cap nhap trong CSDL
                        let _ = dao.updateCustomer(customer: customer)
                    }
                    
                }
            }
        }
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
            //Hien thi cua so note
            let alert = UIAlertController (title: "NOTE", message: "Bạn có muốn xoá khách hàng này không ?", preferredStyle: .alert)
                //Set hanh dong xoa.
            let deleteAction = UIAlertAction(title: "Xoá", style: .destructive){_ in
                //Xoa customer theo id tren database
                let _ = self.dao.deleteCustomerById(id: self.customers[indexPath.row].id)
                //Xoa phan tu ra khoi du lieu
                self.customers.remove(at: indexPath.row)
                //Xoa hang khoi bang
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            //Set huy bo dismiss
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel){_ in
               print("None")
            }
            //Them UIAlertAction vao UIAlertController
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            //goi man hinh controller alert
            present(alert, animated: true)
        }
    
//    }; else if editingStyle == .insert {
//     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     }
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
     
    
    @IBAction func newCustomer(_ sender: Any) {
        // Tao doi tuong man hinh MealDetailController
        let customerDetail = self.storyboard!.instantiateViewController(withIdentifier: "CustomerDetail")
        
        // Danh dau duong di
        navigationType = .newCustomer
        // Chuyen sang man hinh mealDetail
        present(customerDetail, animated:  true)
    }
    
     // MARK: - Navigation
     
    //Chuan bi cho segue va truyen du lieu qua man hinh add customer (edit)
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lấy doi tuong man hinh AddCustomerController
        if let customerDetail = segue.destination as? AddCustomController {
            // Xác đinh của cell được chọn
            if let cell = sender as? CellCustomer {
                // Xác định vị trí cell trong tableView
                if let indexPath = tableView.indexPath(for: cell){
                    // Lấy biến customer cần truyền sang man hinh B
                    let customer = customers[indexPath.row]
                    customerDetail.customer = customer
                    navigationType = .editCustomer
                    // Đánh dấu vị trí indexPath
                    selectedIndexPath = indexPath
                    // Chuyen sang mang hinh customerDetail
                    present(customerDetail, animated: true)
                
                }
                
            }
            
        }
        }
     
    
}
