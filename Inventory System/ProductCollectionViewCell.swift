//
//  ProductCollectionViewCell.swift
//  Inventory System
//
//  Created by tran thu on 25/05/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var unit: UILabel!

    var parent:ListProductViewController?
    var index = 0
    var dao:Database? = nil
    
    //bat su kien tap vao icon eye chuyen sang man hinh moi
    @IBAction func eyeButton(_ sender: UIButton) {
        // Tao doi tuong man hinh ImportExportTable
        if let importExportTable = parent!.storyboard!.instantiateViewController(withIdentifier: "ImportExportTable") as? ImportExportTableViewController {
            //Dua du lieu can truyen vao bien product cua man hinh ImportExportTable
            importExportTable.product = parent!.products[index]
            parent!.selectedIndexPath = index
            //Hien thi man hinh ImportExportTable
            parent!.present(importExportTable, animated: true)
        }
    }
    @IBAction func editButton(_ sender: UIButton) {
        // Tao doi tuong man hinh ImportExportTable
        if let updateProduct = parent!.storyboard!.instantiateViewController(withIdentifier: "updateProduct") as? UpdateProductController {
            //Dua du lieu can truyen vao bien product cua man hinh ImportExportTable
            updateProduct.actionType = .editProduct
            updateProduct.product = parent!.filteredProducts[index]
            parent!.selectedIndexPath = index
            //Hien thi man hinh ImportExportTable
            parent!.present(updateProduct, animated: true)
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        // Tạo hộp thoại cảnh báo
                let alert = UIAlertController(title: "Confirm delete", message: "Deleting the product is equivalent to deleting its import and export information. Are you sure you want to delete it?", preferredStyle: .alert)
                
                // Thêm hành động cho nút "Xoá"
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    // Gọi hàm xoá sản phẩm tại đây
                    self.dao!.deleteProduct(id: Int(self.parent!.filteredProducts[self.index].id))
                    self.dao!.deleteImportExportByProductID(id: Int(self.parent!.filteredProducts[self.index].id))
                    self.parent!.searchbar.text = ""
                    let _ = self.dao!.readProducts(products: &self.parent!.products)
                    self.parent!.filteredProducts = self.parent!.products
                    self.parent!.collectionView.reloadData()
                }))
                
                // Thêm hành động cho nút "Huỷ"
                alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
                
                // Hiển thị hộp thoại cảnh báo
                parent!.present(alert, animated: true, completion: nil)
    }
}
