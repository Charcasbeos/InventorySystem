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
    //2. Select
    ///2.1 Product
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
    
    ///2.2 ImportExport
    func readImportExportsByProductID(productID:Int ,importexports: inout [ImportExport]){
        if open(){
            if  database!.tableExists(IMPORTEXPORT_TABLE_NAME){
                //Cau lenh sql
                let sql = "SELECT * FROM \(IMPORTEXPORT_TABLE_NAME) WHERE \(IMPORTEXPOR_PRODUCTID) = \(productID) ORDER BY \(IMPORTEXPOR_DATE) DESC"
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
                        let productID = result.int(forColumn: IMPORTEXPOR_PRODUCTID)
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
    //3. Update
    ///3.1 Product
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
    
    //4. Delete
    ///4.1 All product
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
    ///4.2 Product
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
}
