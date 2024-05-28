//
//  ProductOfBillCollectionViewCell.swift
//  Inventory System
//
//  Created by DaiTran on 27/5/24.
//

import UIKit

class ProductOfBillCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIProductStepper!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
   
}
