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
        dao.readBills(bills: &bills)
        //Gan gia tri ban dau cho mang filter = bill
        filteredBills = bills
        collectionView.reloadData()
        searchbar.placeholder = "Enter name product"
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
            //Do du lieu vao cell
            cell.customerName.text = "\(bill.customerID)"
            cell.customerPhone.text = "\(bill.customerID)"
            cell.totalBill.text = "\(bill.id)"
            //Lay date
            let date = bill.date
            // Định dạng ngày và giờ
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Định dạng thời gian
            let formattedDate = dateFormatter.string(from: date)
            //Gan date vao label cua cell
            cell.dateBill.text = "\(formattedDate)"
            cell.statusBill.text = "\(bill.status)"
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
