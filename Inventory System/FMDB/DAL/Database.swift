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
    private let IMPORTEXPOR_PRODUCT_ID = "product_id"
    private let IMPORTEXPOR_QUANTITY = "quantity"
    private let IMPORTEXPOR_COST = "cost"
    private let IMPORTEXPOR_DATE = "date"
    //3. Customer
    private let CUSTOMER_TABLE_NAME = "customers"
    private let CUSTOMER_ID = "_id"
    private let CUSTOMER_NAME = "name"
    private let CUSTOMER_PHONE = "phone"
    private let CUSTOMER_ACCUMULATED_MONEY = "accumulated_money"
    //4. Bill
    private let BILL_TABLE_NAME = "bills"
    private let BILL_ID = "_id"
    private let BILL_CUSTOMER_ID = "custormer_id"
    private let BILL_STATUS = "status"
    private let BILL_DATE = "date"
    //4. Bill
    private let BILL_DETAIL_TABLE_NAME = "bill_detail"
    private let BILL_DETAIL_BILL_ID = "bill_id"
    private let BILL_DETAIL_PRODUCT_ID = "product_id"
    private let BILL_DETAIL_PRODUCT_NAME = "product_name"
    private let BILL_DETAIL_PRODUCT_PROFIT = "product_profit"
    private let BILL_DETAIL_PRODUCT_COST = "product_cost"
    private let BILL_DETAIL_QUANTITY = "quantity"

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
            + "\(IMPORTEXPOR_PRODUCT_ID) INTEGER ,"
            + "\(IMPORTEXPOR_QUANTITY) INTEGER ,"
            + "\(IMPORTEXPOR_COST) DOUBLE ,"
            + "\(IMPORTEXPOR_DATE) DEFAULT CURRENT_DATE)"
            //3. Customer
            let sql_customers = "Create table \(CUSTOMER_TABLE_NAME)("
            + "\(CUSTOMER_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(CUSTOMER_NAME) TEXT ,"
            + "\(CUSTOMER_PHONE) TEXT ,"
            + "\(CUSTOMER_ACCUMULATED_MONEY) DOUBLE)"
            //4. Bill
            let sql_bill = "Create table \(BILL_TABLE_NAME)("
            + "\(BILL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(BILL_CUSTOMER_ID) INTEGER ,"
            + "\(BILL_STATUS) INTEGER ,"
            + "\(BILL_DATE) DATE)"
            //4. BillDetail
            let sql_bill_detail = "Create table \(BILL_DETAIL_TABLE_NAME)("
            + "\(BILL_DETAIL_BILL_ID) INTEGER , "
            + "\(BILL_DETAIL_PRODUCT_ID) INTEGER ,"
            + "\(BILL_DETAIL_PRODUCT_NAME) TEXT ,"
            + "\(BILL_DETAIL_PRODUCT_PROFIT) DOUBLE ,"
            + "\(BILL_DETAIL_PRODUCT_COST) DOUBLE ,"
            + "\(BILL_DETAIL_QUANTITY) INTEGER)"
            
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
                if !database!.tableExists(BILL_TABLE_NAME){
                    if createTable(sql: sql_bill){
                        os_log("Tao bang bills thanh cong")
                    }else{
                        os_log("Tao bang bills khong thanh cong")
                    }
                }
                if !database!.tableExists(BILL_DETAIL_TABLE_NAME){
                    if createTable(sql: sql_bill_detail){
                        os_log("Tao bang bill detail thanh cong")
                    }else{
                        os_log("Tao bang bill detail khong thanh cong")
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
            os_log("Dong CSDL")
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
    
    
    ////////////////////////////  1. Products  /////////////////////////////
    ///1.1 Insert
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
                    //Cap nhat id cho product
                    product.id = Int32(database!.lastInsertRowId)
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
    ///1.2 Update
func updateProduct(product:Product)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "UPDATE \(PRODUCT_TABLE_NAME) SET "
                + "\(PRODUCT_NAME) = ?,\(PRODUCT_IMAGE) = ? ,\(PRODUCT_PROFIT) = ?,\(PRODUCT_QUANTITY) = ?, \(PRODUCT_COST) = ?  WHERE \(PRODUCT_ID) = ?"
                //Chuyen UIImage thanh chuoi
                var strImage = ""
                if let image = product.image{
                    //B1. Chuyen anh thanh NSData
                    let nsdataImage = image.pngData()! as NSData
                    //B2. Chuyen nsdataImage thanh chuoi
                    strImage = nsdataImage.base64EncodedString(options: .lineLength64Characters)
                }
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [product.name, strImage, product.profit, product.quantity, product.cost, product.id]){
                    
                    os_log("Sua du lieu product thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    
                    os_log("Sua du lieu product khong thanh cong")
                    
                }
            }
            
        }
        return OK
    }

    ///1.3 ReadAll
 func readProducts(products: inout [Product]){
        if open(){
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql
                let sql = "SELECT * FROM \(PRODUCT_TABLE_NAME) ORDER BY \(PRODUCT_NAME) ASC"
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                    
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                //Thuc hien doc du lieu tu doi tuong FMResultSet,
                //tao bien product moi va dua vao datasource
                if let result = result{
                    products = [Product]()
                    while result.next(){
                        var image:UIImage? = nil
                        let name = result.string(forColumn: PRODUCT_NAME) ?? ""
                        let unit = result.string(forColumn: PRODUCT_UNIT) ?? ""
                        let id = result.int(forColumn: PRODUCT_ID)
                        let quantity = result.int(forColumn: PRODUCT_QUANTITY)
                        let cost = result.double(forColumn: PRODUCT_COST)
                        let profit = result.double(forColumn: PRODUCT_PROFIT)
                        if let strImage = result.string(forColumn: PRODUCT_IMAGE), !strImage.isEmpty{
                            //Buoc 1. Chuyen strImage thanh Data
                            let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                            //Buoc 2. Chuyen dataImage thanh UIImage
                            image = UIImage(data: dataImage!)
                        }
                        
                        //Tao bien product moi tu du lieu doc trong csdl
                        if let product = Product(id:id, name: name, image:image, unit: unit , profit: profit, quantity: Int(quantity), cost: cost){
                            products.append(product)
                            
                        }
                    }
                }
                //Dong csdl
                close()
            }
        }
    }
    ///1.4 ReadOne
func readProductByID(id:Int)->Product?{
        var productRs:Product? = nil
        if open(){
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                
                //Cau lenh sql
                let sql = "SELECT * FROM \(PRODUCT_TABLE_NAME) WHERE \(PRODUCT_ID) = \(id)"
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                    
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                //Thuc hien doc du lieu tu doi tuong FMResultSet,
                //tao bien product moi va dua vao datasource
                if let result = result{
                    while result.next(){
                        var image:UIImage? = nil
                        let name = result.string(forColumn: PRODUCT_NAME) ?? ""
                        let unit = result.string(forColumn: PRODUCT_UNIT) ?? ""
                        let id = result.int(forColumn: PRODUCT_ID)
                        let quantity = result.int(forColumn: PRODUCT_QUANTITY)
                        let cost = result.double(forColumn: PRODUCT_COST)
                        let profit = result.double(forColumn: PRODUCT_PROFIT)
                        if let strImage = result.string(forColumn: PRODUCT_IMAGE), !strImage.isEmpty{
                            //Buoc 1. Chuyen strImage thanh Data
                            let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                            //Buoc 2. Chuyen dataImage thanh UIImage
                            image = UIImage(data: dataImage!)
                        }
                        
                        //Tao bien product moi tu du lieu doc trong csdl
                        if let product = Product(id:id, name: name, image:image, unit: unit , profit: profit, quantity: Int(quantity), cost: cost){
                            productRs = product
                        }
                    }
                }
                //Dong csdl
                close()
            }
        }
        return productRs
    }
    ///1.5 DeleteAll
func deleteAllProducts()->Bool{
        var OK = false
        if open(){
            if database!.tableExists(PRODUCT_TABLE_NAME){
                
                let sql = "DELETE FROM \(PRODUCT_TABLE_NAME)"
                if database!.executeStatements(sql){
                    os_log("Xoa du lieu all product  thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Xoa du lieu all product  khong thanh cong")
                }
            }
        }
        return OK
    }
    ///1.6 Delete By Id
    func deleteProduct(id:Int)->Bool{
        var OK = false
        if open(){
            if database!.tableExists(PRODUCT_TABLE_NAME){
                
                let sql = "DELETE FROM \(PRODUCT_TABLE_NAME) WHERE \(PRODUCT_ID) = \(id)"
                if database!.executeStatements(sql){
                    os_log("Xoa du lieu product  thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Xoa du lieu product  khong thanh cong")
                }
            }
        }
        return OK
    }
    
    
    ////////////////////////////  2.ImportExport  /////////////////////////////
    ///2.1 Insert
    func insertImportExport(importexport:ImportExport)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(IMPORTEXPORT_TABLE_NAME) "
                + "(\(IMPORTEXPOR_PRODUCT_ID),\(IMPORTEXPOR_QUANTITY),\(IMPORTEXPOR_COST),\(IMPORTEXPOR_DATE)) VALUES (?,?,?,?)"
                
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
    ///2.2ReadAll
func readImportExportsByProductID(productID:Int ,importexports: inout [ImportExport]){
        if open(){
            if  database!.tableExists(IMPORTEXPORT_TABLE_NAME){
                //Cau lenh sql
                let sql = "SELECT * FROM \(IMPORTEXPORT_TABLE_NAME) WHERE \(IMPORTEXPOR_PRODUCT_ID) = \(productID) ORDER BY \(IMPORTEXPOR_DATE) DESC"
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                    
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                //Thuc hien doc du lieu tu doi tuong FMResultSet,
                //tao bien importexport moi va dua vao datasource
                if let result = result{
                    importexports = [ImportExport]()
                    while result.next(){
                        let productID = result.int(forColumn: IMPORTEXPOR_PRODUCT_ID)
                        let quantity = result.int(forColumn: IMPORTEXPOR_QUANTITY)
                        let cost = result.double(forColumn: IMPORTEXPOR_COST)
                        let date = result.date(forColumn: IMPORTEXPOR_DATE) ?? Date()
                        
                        //Tao importexport meal moi tu du lieu doc trong csdl
                        let importexport = ImportExport(productID: Int(productID), quantity: Int(quantity), cost: cost, date: date)
                        importexports.append(importexport)
                        
                    }
                }
                //Dong csdl
                close()
            }
        }
    }
    //1.3 Delete by Product ID
    func deleteImportExportByProductID(id:Int)->Bool{
        var OK = false
        if open(){
            if database!.tableExists(PRODUCT_TABLE_NAME){
                
                let sql = "DELETE FROM \(IMPORTEXPORT_TABLE_NAME) WHERE \(IMPORTEXPOR_PRODUCT_ID) = \(id)"
                if database!.executeStatements(sql){
                    os_log("Xoa du lieu export by product id  thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Xoa du lieu  export by product id   khong thanh cong")
                }
            }
        }
        return OK
    }
    
    ////////////////////////////  3. Customers  /////////////////////////////
    ///3.1 Insert
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
    ///3.3 Read customer by id
    func readCustomerByID(customer_id:Int)->Customer? {
        var customerRs:Customer? = nil
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // Câu lệnh sql truy vấn dữ liệu từ csdl
                let sql = "SELECT * FROM \(CUSTOMER_TABLE_NAME) WHERE \(CUSTOMER_ID) = \(customer_id)"
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
                           customerRs = customer
                        }
                    }
                }
            }
        }
        return customerRs
    }
    ///3.4 Read customer_id by phone
    func findCustomerByPhone(phone:String)->Int {
        var customer_id:Int = -1
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // Câu lệnh sql truy vấn dữ liệu từ csdl
//                let sql = "SELECT \(CUSTOMER_ID) FROM \(CUSTOMER_TABLE_NAME) WHERE \(CUSTOMER_PHONE) = \(phone)"
                let sql = "SELECT \(CUSTOMER_ID) FROM \(CUSTOMER_TABLE_NAME) WHERE \(CUSTOMER_PHONE) = ?"
                // Khai báo biến chứa dữ liệu trả về
                var result:FMResultSet?
                do {
                    result = try database!.executeQuery(sql, values: [phone])
                    os_log("Truy vấn csdl thành công")
                }
                catch {
                    os_log("Không thể truy vấn csdl")
                }
                
                // Đọc dữ liệu ra từ đối tượng result
                if let result = result {
                    while result.next() {
                        customer_id = Int(result.int(forColumn: CUSTOMER_ID))
                        
                    }
                }
                close()
                
            }
        }
        print("\(customer_id)")
        return customer_id
    }
    ////3.5 Delete Custome
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
    ///3.6 Update Customer
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
    
    ////////////////////////////  4. Bills  /////////////////////////////
    //4.1 Insert
    func insertBill(bill:Bill)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(PRODUCT_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(BILL_TABLE_NAME) "
                + "(\(BILL_CUSTOMER_ID),\(BILL_STATUS),\(BILL_DATE)) VALUES (?,?,?)"
                
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [bill.customerID, bill.status, bill.date]){
                    os_log("Them du lieu bill thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Them du lieu bill khong thanh cong")
                }
            }
            
        }
        return OK
    }
    ///4.2 Update
    func updateSatusBill(billID:Int,status:Int)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(BILL_TABLE_NAME){
                //Cau lenh sql de cap nhat du lieu vao CSDL
                let sql = "UPDATE \(BILL_TABLE_NAME) SET "
                + "\(BILL_STATUS) = ? WHERE \(BILL_ID) = ?"
                
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [status,billID]){
                    os_log("Cap nhat trang thai bill thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Cap nhat trang thai bill khong thanh cong")
                }
            }
            
        }
        return OK
    }
///4.3 read list bill
    func readBills(bills: inout [Bill]){
        if open(){
            if  database!.tableExists(BILL_TABLE_NAME){
                //Cau lenh sql
                let sql = "SELECT * FROM \(BILL_TABLE_NAME) ORDER BY \(BILL_DATE) DESC"
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                    
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                //Thuc hien doc du lieu tu doi tuong FMResultSet,
                //tao bien product moi va dua vao datasource
                if let result = result{
                    bills = [Bill]()
                    while result.next(){
                        let id = result.int(forColumn: BILL_ID)
                        let customer_id = result.int(forColumn: BILL_CUSTOMER_ID)
                        let status = result.int(forColumn: BILL_STATUS)
                        let date = result.date(forColumn: BILL_DATE) ?? Date()
                        //Tao bien bill moi tu du lieu doc trong csdl
                        let bill = Bill(id: id, customerID: customer_id, status: status, date: date)
                        bills.append(bill)
                        
                    }
                }
            }
            //Dong csdl
            close()
        }
    }
    
    ////////////////////////////  5. BillDetail  /////////////////////////////
    ///5.1 Insert
    func insertBillDetail(billDetail:BillDetail)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(BILL_DETAIL_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "INSERT INTO \(BILL_DETAIL_TABLE_NAME) "
                + "(\(BILL_DETAIL_BILL_ID),\(BILL_DETAIL_PRODUCT_ID),\(BILL_DETAIL_PRODUCT_NAME),\(BILL_DETAIL_PRODUCT_PROFIT),\(BILL_DETAIL_PRODUCT_COST),\(BILL_DETAIL_QUANTITY) VALUES (?,?,?,?,?,?)"
                
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [billDetail.billID,billDetail.productID,billDetail.productName,billDetail.productProfit, billDetail.productCost, billDetail.quantity]){
                    os_log("Them du lieu bill detail thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Them du lieu bill detail khong thanh cong")
                }
            }
            
        }
        return OK
    }
    ///5.2 Update
    func updateBillDetail(billDetail:BillDetail)->Bool{
        var OK = false
        if open(){
            //Kiem tra su ton tai cua bang du lieu
            if  database!.tableExists(BILL_DETAIL_TABLE_NAME){
                //Cau lenh sql de them du lieu vao CSDL
                let sql = "UPDATE \(BILL_DETAIL_TABLE_NAME) "
                + "SET \(BILL_DETAIL_PRODUCT_NAME) = ? ,\(BILL_DETAIL_PRODUCT_PROFIT) = ? ,\(BILL_DETAIL_PRODUCT_COST) = ? ,\(BILL_DETAIL_QUANTITY) = ? WHERE \(BILL_DETAIL_BILL_ID) = ? AND \(BILL_DETAIL_PRODUCT_ID) = ? "
                
                //Luu gia tri meal vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [billDetail.billID,billDetail.productID,billDetail.productName,billDetail.productProfit, billDetail.productCost, billDetail.quantity]){
                    os_log("Sua du lieu bill detail thanh cong")
                    OK = true
                    //Dong co so du lieu
                    close()
                }
                else{
                    os_log("Sua du lieu bill detail khong thanh cong")
                }
            }
            
        }
        return OK
    }
    ///5.3 dateMin  < bill.date < dateMax
    func billDetailFromTo(dateMin:Date, dateMax:Date, listBillDetailFromTo: inout [BillDetail]){
        if open(){
            if database!.tableExists(BILL_TABLE_NAME) && database!.tableExists(BILL_DETAIL_TABLE_NAME){
                let sql = "SELECT * FROM \(BILL_DETAIL_TABLE_NAME) WHERE \(BILL_DETAIL_BILL_ID) IN (SELECT \(BILL_ID) FROM \(BILL_TABLE_NAME) WHERE \(BILL_DATE) > ?  AND \(BILL_DATE) < ?)"
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                result = database!.executeQuery(sql, withArgumentsIn: [dateMin,dateMax])
                
                //Thuc hien doc du lieu tu doi tuong FMResultSet,
                 
                if let result = result{
                listBillDetailFromTo = [BillDetail]()
                    while result.next(){
                        let bill_id = result.int(forColumn: BILL_DETAIL_BILL_ID)
                        let product_name = result.string(forColumn: BILL_DETAIL_PRODUCT_NAME) ?? ""
                        let product_id = result.int(forColumn: BILL_DETAIL_PRODUCT_ID)
                        let product_profit = result.double(forColumn: BILL_DETAIL_PRODUCT_PROFIT)
                        let product_cost = result.double(forColumn: BILL_DETAIL_PRODUCT_COST)
                        let quantity = result.int(forColumn: BILL_DETAIL_QUANTITY)
                        let bill_detail = BillDetail(billID: Int32(bill_id), productID: Int32(product_id), productName: product_name, productProfit: product_profit, productCost: product_cost, quantity: Int(quantity))
                            
                        listBillDetailFromTo.append(bill_detail)
                    }
                }
            }
            close()
        }
    }
    ///5.4 Top 3 seller
    func getTopSeller(dateMin:Date, dateMax:Date, productIDs: inout [Int], quatities: inout [Int]){
        if open(){
            if database!.tableExists(BILL_TABLE_NAME) && database!.tableExists(BILL_DETAIL_TABLE_NAME){
                let sql = "SELECT \(BILL_DETAIL_TABLE_NAME).\(BILL_DETAIL_PRODUCT_ID), SUM(\(BILL_DETAIL_TABLE_NAME).\(BILL_DETAIL_QUANTITY)) AS total_quantity"
                + "FROM \(BILL_DETAIL_TABLE_NAME)"
                + "JOIN \(BILL_TABLE_NAME) ON \(BILL_DETAIL_TABLE_NAME).\(BILL_DETAIL_BILL_ID) = \(BILL_TABLE_NAME).\(BILL_ID)"
                + "WHERE \(BILL_TABLE_NAME).\(BILL_DATE) >= ? AND \(BILL_TABLE_NAME).\(BILL_DATE) <= ?"
                + "GROUP BY \(BILL_DETAIL_TABLE_NAME).\(BILL_DETAIL_PRODUCT_ID)"
                + "ORDER BY total_quantity DESC"
                + "LIMIT 3"
                
                //Du lieu doc ve tu CSDL
                var result:FMResultSet?
                result = database!.executeQuery(sql, withArgumentsIn: [dateMin,dateMax])
                if let result = result{
                    productIDs = [Int]()
                    quatities = [Int]()
                    while result.next(){
                        let productId = result.int(forColumn: BILL_DETAIL_PRODUCT_ID)
                        productIDs.append(Int(productId))
                        let quantity = result.int(forColumn: "total_quantity")
                        quatities.append(Int(quantity))
                    }
                    
                }
            }
            close()
        }
       
    }
}
  

