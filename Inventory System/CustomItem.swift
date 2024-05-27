//
//  CustomItem.swift
//  Inventory System
//
//

import UIKit

class CustomItem: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //@IbInspce dung de chinh sua va hien thi truc tiep len atribute trong storyboard
    //Tao thuoc tinh
    //Layer là thuộc tính đối tượng là lớp con của UIView
    //bo goc
    @IBInspectable var connerRadius : CGFloat = 0.0 {
        //Set lai gia trị khi coder nhap
            didSet{
                layer.cornerRadius = connerRadius
            }
        }
    //Do dai vien
        @IBInspectable var boderWidth : CGFloat = 0.0 {
            didSet{
                layer.borderWidth = boderWidth
            }
        }
    //Mau vien
        @IBInspectable var borderColor: UIColor? {
             didSet {
                 layer.borderColor = borderColor?.cgColor
             }
         }
     //Do mo cua bong
         @IBInspectable var shadowOpacity: Float = 0.0 {
             didSet {
                 layer.shadowOpacity = shadowOpacity
             }
         }
    // Bong theo canh ngang
        @IBInspectable var shadowOffsetX: CGFloat = 0 {
                didSet {
                    updateShadowOffset()
                }
            }
     //Bong theo canh doc
            @IBInspectable var shadowOffsetY: CGFloat = 0 {
                didSet {
                    updateShadowOffset()
                }
            }
       // Xu ly huong x , y
            private func updateShadowOffset() {
                //Tao do lech cua bong theo huong x , y
                //
                layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
            }

    
}
