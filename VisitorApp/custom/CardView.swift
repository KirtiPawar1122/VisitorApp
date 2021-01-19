//  CardView.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 26/11/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.

import Foundation
import UIKit

@available(iOS 13.0, *)
@IBDesignable class CardView: UIView {
    
    var conrnerRadius: CGFloat = 5
    var offsetWidth: CGFloat = 5
    var offsetHeight: CGFloat = 5
    var offsetShadowOpacity: Float = 5
    var color = UIColor.systemGray2
    
    override func layoutSubviews() {
        layer.cornerRadius = self.conrnerRadius
        layer.shadowColor = self.color.cgColor
        //layer.shadowOffset = CGSize(width: self.offsetWidth, height: self.offsetHeight)
        //layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.conrnerRadius).cgPath
        layer.shadowOpacity = self.offsetShadowOpacity
    }
}
