//
//  General Functions.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 28.08.22.
//

import Foundation
import UIKit

let randomColors: [UIColor] = [
    .systemPurple,
    .systemRed,
    .systemBlue,
    .systemCyan,
    .systemFill,
    .systemGray,
    .systemMint,
    .systemPink,
    .systemTeal,
    .systemBrown,
    .systemGreen,
    .systemIndigo,
    .systemOrange,
    .systemYellow
]

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

func createLabel(textColor: UIColor, fontSize: Int, fontWeight: String) -> UILabel {
    let label = UILabel()
    label.textColor = textColor
    label.font = UIFont(name: fontWeight, size: CGFloat(fontSize))
    label.textAlignment = .left
    label.numberOfLines = 1
    return label
}

func createImageView(imageName: String) -> UIImageView {
    let view = UIImageView()
    view.image = UIImage(systemName: imageName)
    return view
}
