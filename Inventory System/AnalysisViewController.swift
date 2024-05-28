//
//  AnalysisViewController.swift
//  Inventory System
//
//  Created by tran thu on 28/05/2024.
//

import UIKit

class AnalysisViewController: UIViewController {

    @IBOutlet weak var dateFrom: UIDatePicker!
    @IBOutlet weak var dateTo: UIDatePicker!
    
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var revenue: UILabel!
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    
    @IBOutlet weak var quantity3: UILabel!
    @IBOutlet weak var quantity2: UILabel!
    @IBOutlet weak var quantity1: UILabel!
    
    private let dao = Database()
    var listBillDetailFromTo = [BillDetail]()
    var totalRevenue:Double = 0.0
    var totalCost:Double = 0.0
    var price:Double = 0.0
    var productIDs = [Int]()
    var quantities = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePicker()
        // Do any additional setup after loading the view.
    }
    func setUpDatePicker(){
        //Maxinum la ngay hien tai
        dateFrom.maximumDate = Date()
        dateTo.maximumDate = Date()
        //Default
        dateFrom.date = Date()
        dateTo.date = Date()

    }
    
    @IBAction func dateFromChange(_ sender: UIDatePicker) {
        if dateFrom.date > dateTo.date {
            dateTo.date = dateFrom.date
        }
        getValueByDate(dateMin: dateFrom.date, dateMax: dateTo.date)
    }
    
    @IBAction func dateToChange(_ sender: UIDatePicker) {
        if dateTo.date < dateFrom.date {
                    dateFrom.date = dateTo.date
                }
        getValueByDate(dateMin: dateFrom.date, dateMax: dateTo.date)
    }
    
    //Get value
    func getValueByDate(dateMin:Date, dateMax:Date){
        dao.billDetailFromTo(dateMin: dateMin, dateMax: dateMax, listBillDetailFromTo: &listBillDetailFromTo)
         totalRevenue = 0.0
         totalCost = 0.0
        price = 0.0
        //Tinh tong doanh thu from dateMin to dateMax
        for item in listBillDetailFromTo{
            price = item.productCost * (1+(item.productProfit)/100)
            totalRevenue += Double(item.quantity) * price
            totalCost += Double(item.quantity) * item.productCost
        }
        revenue.text = "\(totalRevenue)"
        cost.text = "\(totalCost)"
        profit.text = "\(totalRevenue - totalCost)"
        
        //Top 3 seller
        dao.getTopSeller(dateMin: dateMin, dateMax: dateMax, productIDs: &productIDs, quatities: &quantities)
        if productIDs.count > 0 && quantities.count > 0{
            let product1 = dao.readProductByID(id: productIDs[0])
            let product2 = dao.readProductByID(id: productIDs[1])
            let product3 = dao.readProductByID(id: productIDs[2])
            
            quantity1.text = "\(quantities[0])"
            quantity2.text = "\(quantities[1])"
            quantity3.text = "\(quantities[3])"
            
            if let product1 = product1{
                image1.image = product1.image
            }
            if let product2 = product2{
                image2.image = product2.image
            }
            if let product3 = product3{
                image3.image = product3.image
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
