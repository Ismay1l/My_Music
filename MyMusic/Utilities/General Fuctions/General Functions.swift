//
//  General Functions.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 28.08.22.
//

import Foundation
import UIKit

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func createLabel(textColor: UIColor, fontSize: Int, fontWeight: UIFont.Weight) -> UILabel {
    let label = UILabel()
    label.textColor = textColor
    label.font = .systemFont(ofSize: CGFloat(fontSize), weight: fontWeight)
    label.textAlignment = .left
    label.numberOfLines = 1
    return label
}
