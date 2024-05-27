//
//  Database.swift
//  Inventory System
//
//  Created by tran thu on 22/05/2024.
//

import Foundation
import UIKit
import os.log

class Database {
    //MARK: Cac thoc tinh chung cua co so du lieu
    private let DB_NAME = "inventory.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    
    
    //MARK: Cac thuoc tinh lien quan den bang du lieu
    //1.Product
    private let PRODUCT_TABLE_NAME = "products"
    private let PRODUCT_ID = "_id"
    private let PRODUCT_NAME = "name"
    private let PRODUCT_IMAGE = "image"
    private let PRODUCT_UNIT = "unit"
    private let PRODUCT_PROFIT = "profit"
    private let PRODUCT_QUANTITY = "quantity" //So luong ton kho
    private let PRODUCT_COST = "cost" //Gia cost trung binh
    //2.ImportExport
    private let IMPORTEXPORT_TABLE_NAME = "import_export"
    private let IMPORTEXPORT_ID = "_id"
    private let IMPORTEXPOR_PRODUCTID = "productID"
    private let IMPORTEXPOR_QUANTITY = "quantity"
    private let IMPORTEXPOR_COST = "cost"
    private let IMPORTEXPOR_DATE = "date"
    //3. Customer
    private let CUSTOMER_TABLE_NAME = "customers"
    private let CUSTOMER_ID = "_id"
    private let CUSTOMER_NAME = "name"
    private let CUSTOMER_PHONE = "phone"
    private let CUSTOMER_ACCUMULATED_MONEY = "accumulated_money"
    
    
    //MARK: Constructor
    init(){
        //Lay tat ca duong dan den cac thu muc doccument trong mot ung dung iOS
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true);
        //Khoi tao DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        //Khoi tao doi tuong database
        database = FMDatabase(path: DB_PATH)
        //Kiem tra su thanh cong cua database
        if database != nil {
            os_log("Tao CSDL thanh cong !")
            //Thuc hien tao bang du lieu
            //1.Products
            let sql_products = "Create table \(PRODUCT_TABLE_NAME)("
            + "\(PRODUCT_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(PRODUCT_NAME) TEXT ,"
            + "\(PRODUCT_IMAGE) TEXT ,"
            + "\(PRODUCT_UNIT) TEXT ,"
            + "\(PRODUCT_PROFIT) DOUBLE,"
            + "\(PRODUCT_QUANTITY) INTEGER,"
            + "\(PRODUCT_COST) DOUBLE)"
            //2.ImportExport
            let sql_import_export = "Create table \(IMPORTEXPORT_TABLE_NAME)("
            + "\(IMPORTEXPORT_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(IMPORTEXPOR_PRODUCTID) INTEGER ,"
            + "\(IMPORTEXPOR_QUANTITY) INTEGER ,"
            + "\(IMPORTEXPOR_COST) DOUBLE ,"
            + "\(IMPORTEXPOR_DATE) DEFAULT CURRENT_DATE)"
            //3. Customer
            let sql_customers = "Create table \(CUSTOMER_TABLE_NAME)("
            + "\(CUSTOMER_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(CUSTOMER_NAME) TEXT ,"
            + "\(CUSTOMER_PHONE) TEXT ,"
            + "\(CUSTOMER_ACCUMULATED_MONEY) DOUBLE)"
            
            if open(){
                if !database!.tableExists(PRODUCT_TABLE_NAME){
                    if createTable(sql: sql_products){
                        os_log("Tao bang product thanh cong")
                    }
                    else{
                        os_log("Tao bang product khong thanh cong")
                    }
                }
                if !database!.tableExists(IMPORTEXPORT_TABLE_NAME){
                    if createTable(sql: sql_import_export){
                        os_log("Tao bang importexport thanh cong")
                    }else{
                        os_log("Tao bang importexport khong thanh cong")
                    }
                }
                if !database!.tableExists(CUSTOMER_TABLE_NAME){
                    if createTable(sql: sql_customers){
                        os_log("Tao bang customers thanh cong")
                    }else{
                        os_log("Tao bang customers khong thanh cong")
                    }
                }
            }
            
            
        }
        else{
            os_log("Tao CSDL khong thanh cong !")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham primitive cua CSDL
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //1. Mo CSDL
    private func open()->Bool{
        var OK = false
        if let database = database {
            if database.open(){
                os_log("Mo CSDL thanh cong")
                OK = true
            }
            else{
                os_log("Mo CSDL khong thanh cong")
            }
        }
        
        return OK
    }
    //2. Dong CSDL
    private func close(){
        if let database = database {
            database.close()
        }
        
    }
    //3. Tao bang du lieu
    private func createTable(sql:String)->Bool{
        var OK = false
        if database!.executeStatements(sql){
            OK = true
        }
        return OK
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham APIs cua CSDL
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //1. Insert
    ///1.1 Products
    func insertProduct(product:Product)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(PRODUCT_TABLE_NAME) "
                + "(\(PRODUCT_NAME),\(PRODUCT_IMAGE),\(PRODUCT_UNIT),\(PRODUCT_PROFIT),\(PRODUCT_QUANTITY),\(PRODUCT_COST)) VALUES (?,?,?,?,?,?)"
                //Chuyen UIImage thanh chuoi
                var strImage = ""
                if let image = product.image{
                    //B1. Chuyen anh thanh NSData
                    let nsdataImage = image.pngData()! as NSData
                    //B2. Chuyen nsdataImage thanh chuoi
                    strImage = nsdataImage.base64EncodedString(options: .lineLength64Characters)
                }
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [product.name, strImage, product.unit, product.profit,product.quantity, product.cost]){
                    os_log("Them du lieu product thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Them du lieu product khong thanh cong")
                }
            }
            
        }
        return OK
    }
    ///1.2 ImportExport
    func insertImportExport(importexport:ImportExport)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(IMPORTEXPORT_TABLE_NAME) "
                + "(\(IMPORTEXPOR_PRODUCTID),\(IMPORTEXPOR_QUANTITY),\(IMPORTEXPOR_COST),\(IMPORTEXPOR_DATE)) VALUES (?,?,?,?)"
                
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [importexport.productID, importexport.quantity, importexport.cost, importexport.date]){
                    os_log("Them du lieu importexport thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Them du lieu importexport khong thanh cong")
                }
            }
            
        }
        return OK
    }
    
    //3. Insert
    ///3.1 Customers
    func insertCustomer(customer:Customer)->Bool{
        
        
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(CUSTOMER_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(CUSTOMER_TABLE_NAME) "
                + "(\(CUSTOMER_NAME) ,\(CUSTOMER_PHONE),\(CUSTOMER_ACCUMULATED_MONEY)) VALUES (?,?,?)"
               
                //Luu gia tri customer vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [customer.name,customer.phoneNumber,customer.accumulatedMoney]){
                    os_log("Them du lieu customer thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Them du lieu customer khong thanh cong")
                }
            }
            
        }
        return OK
    }
    //// 3.2 Read Customer
    func readAllCustomer(customers: inout [Customer]) {
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // Câu lệnh sql truy vấn dữ liệu từ csdl
                let sql = "SELECT * FROM \(CUSTOMER_TABLE_NAME) ORDER BY \(CUSTOMER_ID) DESC"
                // Khai báo biến chứa dữ liệu trả về
                var result:FMResultSet?
                do {
                    os_log("Truy vấn csdl thành công")
                    result = try database!.executeQuery(sql, values: nil)
                }
                catch {
                    os_log("Không thể truy vấn csdl")
                }
                // Đọc dữ liệu ra từ đối tượng result
                if let result = result {
                    while result.next() {
                        let name = result.string(forColumn: CUSTOMER_NAME) ?? ""
                        let phone  = result.string(forColumn: CUSTOMER_PHONE) ?? ""
                        let accumulated_money = result.double(forColumn: CUSTOMER_ACCUMULATED_MONEY)
                        let id = result.int(forColumn: CUSTOMER_ID)
                        // Tạo đối tượng customer từ dữ liệu đọc được
                        if let customer = Customer(name: name, phoneNumber: phone, accumulatedMoney: accumulated_money,id: id) {
                            customers.append(customer)
                        }
                    }
                }
            }
        }
    }
    ////3.3 Delete Custome
    func deleteCustomerById(id:Int32) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // cau lenh
                let sql = "DELETE FROM \(CUSTOMER_TABLE_NAME) WHERE \(CUSTOMER_ID) = ?"
                // THUC THI
                if database!.executeUpdate(sql, withArgumentsIn: [id]) {
                    os_log("xoa phan tu \(id) thanh cong")
                    OK = true
                }
                else {
                    os_log("xoa phan tu \(id) thanh bai")
                }
                close()
            }
        }
        return OK;
    }
    ///3.4 Update Customer
    func updateCustomer(customer:Customer) ->Bool {
        var OK = false
        if open(){
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // CAU LENH
                let sql = "UPDATE \(CUSTOMER_TABLE_NAME) SET \(CUSTOMER_NAME) = ?, \(CUSTOMER_PHONE) = ?, \(CUSTOMER_ACCUMULATED_MONEY) = ? WHERE \(CUSTOMER_ID) = ?"
               
                //THUC thi cau lenh sql
                if database!.executeUpdate(sql, withArgumentsIn: [customer.name, customer.phoneNumber, customer.accumulatedMoney, customer.id]) {
                    os_log("cap nhap customer thu \(customer.id) thanh cong ")
                    OK = true
                }
                else {
                    os_log("cap nhap customer thu \(customer.id) ko thanh cong ")
                }
                //dong
                close()
            }
        }
        return OK;
    }
}
