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
}
