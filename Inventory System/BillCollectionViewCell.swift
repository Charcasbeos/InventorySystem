//
//  BillCollectionViewCell.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
//

import UIKit

class BillCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var statusBill: UILabel!
    @IBOutlet weak var dateBill: UILabel!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    var parent:ListBillViewController?
    var index = 0
    var dao:Database? = nil
    
    @IBAction func showDetail(_ sender: UIButton) {
        //Lay vi tri cell tap vao
        // Lay ID bill tai vi tri cell dc tap vao
        //Chuyen du lieu sang man hinh confirm voi status da thanh toan
    }
}
