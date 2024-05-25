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
    @IBInspectable var connerRadius : CGFloat = 0.0 {
            didSet{
                layer.cornerRadius = connerRadius
            }
        }
        @IBInspectable var boderWidth : CGFloat = 0.0 {
            didSet{
                layer.borderWidth = boderWidth
            }
        }
        @IBInspectable var borderColor: UIColor? {
             didSet {
                 layer.borderColor = borderColor?.cgColor
             }
         }

         @IBInspectable var shadowOpacity: Float = 0.0 {
             didSet {
                 layer.shadowOpacity = shadowOpacity
             }
         }
        @IBInspectable var shadowOffsetX: CGFloat = 0 {
                didSet {
                    updateShadowOffset()
                }
            }

            @IBInspectable var shadowOffsetY: CGFloat = 0 {
                didSet {
                    updateShadowOffset()
                }
            }

            private func updateShadowOffset() {
                layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
            }

    
}
