//
//  Color+Hex.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let cleanedHexString = hexString

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

}
