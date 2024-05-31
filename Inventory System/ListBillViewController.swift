//
//  ListBillViewController.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
//

import UIKit

class ListBillViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    //Vi tri cell duoc tap
    var selectedIndexPath:Int = 0
    
    //Mang bills
    var bills = [Bill]()
    var filteredBills = [Bill]()
    //Khai bao doi tuong xu dung CSDL
    private let dao = Database()
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        //Doc du lieu bill tren csdl
        
        dao.readBillsByStatus(bills: &bills, status: 1)
        
        
        //Gan gia tri ban dau cho mang filter = bill
        filteredBills = bills
        collectionView.reloadData()
        searchbar.placeholder = "Input customer phone and search"
    }
    // MARK: - UISearchBar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredBills = bills
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let phone = searchBar.text, !phone.isEmpty{
            print("phone \(phone)")
            //Truy cap csdl de lay customerID
            let customer_id = dao.findCustomerByPhone(phone: phone)
            if customer_id != -1{
                print("cus_id \(customer_id)")
                //Loc bill tu customer_id
                filteredBills = bills.filter{(bill: Bill) -> Bool in
                    return bill.customerID == customer_id
                }
                for item in filteredBills {
                    print("billID \(item.id)")
                }
                collectionView.reloadData()
            }
            else{
                filteredBills = [Bill]()
                collectionView.reloadData()
            }
        }
        
        searchBar.resignFirstResponder()
    }
    
    //MARK: Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "BillCollectionViewCell"
        // Tao cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? BillCollectionViewCell{
            //Lay phan tu thu i trong mang
            let bill = filteredBills[indexPath.row]
            //Tim customer
            if let customerRs = dao.findCustomerById(id: Int(bill.customerID)){
                //Do du lieu vao cell
                cell.parent = self
                cell.dao = dao
                cell.index = indexPath.row
                cell.customerName.text = "\(customerRs.name)"
                cell.customerPhone.text = "\(customerRs.phoneNumber)"
                //Gan date vao label cua cell
                cell.dateBill.text = "\(bill.date)"
                
                
            }
            
            else{
                //Do du lieu vao cell
                cell.parent = self
                cell.dao = dao
                cell.index = indexPath.row
                cell.customerName.text = "unknown"
                cell.customerPhone.text = "unknown"
                //Gan date vao label cua cell
                cell.dateBill.text = "\(bill.date)"
                
            }
            var listBillDetailById = [BillDetail]()
            var total:Double = 0.0
            dao.listBillDetailByBillId(billId: Int(bill.id), listBillDetailById: &listBillDetailById)
            for item in listBillDetailById{
                let unit = dao.readProductByID(id: Int(item.productID))!.unit
                var product = Product(id: item.productID,name: item.productName, unit:unit , profit: item.productProfit, quantity: 0, cost: item.productCost)
                var price:Double = item.productCost*(100+item.productProfit)/100
                total += Double(item.quantity) * price
            }
            cell.total.text = "\(String(format: "%.2f",total)) VND"
            
            return cell
        }
        
    // Dung khi co loi nghiem trong
    fatalError("Khong the tao cell!")
}
    

    // MARK: - Navigation

    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
