//
//  ProductOfBillCell.swift
//  Inventory System
//
//  Created by DaiTran on 25/5/24.
//

import UIKit

class ProductOfBillCell: UITableViewCell {

    //MARK: Properties
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIProductStepper!
    
    var onTapped: UIGestureRecognizer?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if let onTapped = onTapped{
            onTapped.delegate = self
        }

        // Configure the view for the selected state
    }
        
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.contentView)
    }
   
}
