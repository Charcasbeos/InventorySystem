//
//  BillCollectionViewCell.swift
//  Inventory System
//
//  Created by tran thu on 27/05/2024.
//

import UIKit

class BillCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var dateBill: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    var parent:ListBillViewController?
    var index = 0
    var dao:Database? = nil
    
    @IBAction func showDetail(_ sender: UIButton) {
        if let confirm = parent!.storyboard!.instantiateViewController(withIdentifier: "showOrderConfirmation") as? OrderConfirmationViewController {
            //Gan billID sang Confirm
            confirm.billFromBillCell  = parent!.bills[index]
            parent!.present(confirm, animated: true)
        }
    }
}
