//
//  HomeController.swift
//  Inventory System
//
//  Created by Do Ngoc Hieu on 21/05/2024.
//

import UIKit

class HomeController: UIViewController {

    // Gan cac item vao code
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var analysisView: UIView!
    @IBOutlet weak var createBillView: UIView!
    @IBOutlet weak var storageView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var draftView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                //Gan tap
        createBillView.tag = 1
        storageView.tag = 2
        historyView.tag = 3
        analysisView.tag = 4
        customerView.tag = 5
        draftView.tag = 6
             
        addTapGesture(to: createBillView, action: #selector(handleTap(_:)))
        addTapGesture(to: storageView, action: #selector(handleTap(_:)))
        addTapGesture(to: historyView, action: #selector(handleTap(_:)))
        addTapGesture(to: analysisView, action: #selector(handleTap(_:)))
        addTapGesture(to: customerView, action: #selector(handleTap(_:)))
        addTapGesture(to: draftView, action: #selector(handleTap(_:)))
            }
            
            // Add Tap
            private func addTapGesture(to view: UIView, action: Selector) {
              
                let tapGesture = UITapGestureRecognizer(target: self, action: action)
                //Ket noi doi tuong vao view
                view.addGestureRecognizer(tapGesture)
            }
            
            // Xu ly ham tap
            @objc private func handleTap(_ sender: UITapGestureRecognizer) {
                guard let tappedView = sender.view else { return }
                
                switch tappedView.tag {
                case 1:
                    //Xem tap da tap chua
                    print("1 view tapped")
                case 2:
                    //Xem tap da tap chua
                    print("2 view tapped")
                case 3:
                    //Xem tap da tap chua
                    print("3 view tapped")
                case 4:
                    //Xem tap da tap chua
                    print("4 view tapped")
                case 5:
                    //Chuyen trang
                    if let customer = self.storyboard!.instantiateViewController(withIdentifier: "Customer") as? CustomerTableViewController
                    {
                        present(customer, animated: true)
                    }
                case 6:
                    //Xem tap da tap chua
                    print("6 view tapped")
                default:
                    break
                }
            }

            // MARK: - Navigation
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
            }
}
