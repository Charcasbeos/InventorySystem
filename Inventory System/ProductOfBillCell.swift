//
//  ProductOfBillCell.swift
//  Inventory System
//
//  Created by DaiTran on 25/5/24.
//

import UIKit
import OSLog

class ProductOfBillCell: UITableViewCell {

    //MARK: Properties
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIProductStepper!
        
    
    var onTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none3
        
    }

    
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.contentView)
    }
   
    
}
