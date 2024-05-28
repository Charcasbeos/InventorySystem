//
//  UIOrderComfirmationViewCell.swift
//  Inventory System
//
//  Created by DaiTran on 28/5/24.
//

import UIKit

class UIOrderComfirmationViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
