//
//  ViewController.swift
//  Inventory System
//
//  Created by DaiTran on 2/5/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.layer.cornerRadius = 18
        backGround.layer.masksToBounds = true
    }

    @IBOutlet var backGround: UIView!
    
}

