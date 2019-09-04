//
//  UIColorExtension.swift
//  SingularKey
//
//  Created by neetin on 1/16/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//
import UIKit

extension UIColor {
  convenience init(hex: String) {
    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    var alpha: CGFloat = 1.0
    var hex:   String = hex
    if hex.hasPrefix("#") {
      let index = hex.index(hex.startIndex, offsetBy: 1)
      hex = String(hex[index...])
    }
    let scanner = Scanner(string: hex)
    var hexValue: CUnsignedLongLong = 0
    if scanner.scanHexInt64(&hexValue) {
      switch (hex.count) {
      case 3:
        red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
        green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
        blue  = CGFloat(hexValue & 0x00F)              / 15.0
      case 4:
        red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
        green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
        blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
        alpha = CGFloat(hexValue & 0x000F)             / 15.0
      case 6:
        red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
        green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
        blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
      case 8:
        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
        alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
      default:
        print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
      }
    } else {
      print("Scan hex error")
    }
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
  var hexString: String? {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    let multiplier = CGFloat(255.999999)
    guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
      return nil
    }
    if alpha == 1.0 {
      return String(
        format: "#%02lX%02lX%02lX",
        Int(red * multiplier),
        Int(green * multiplier),
        Int(blue * multiplier)
      )
    } else {
      return String(
        format: "#%02lX%02lX%02lX%02lX",
        Int(red * multiplier),
        Int(green * multiplier),
        Int(blue * multiplier),
        Int(alpha * multiplier)
      )
    }
  }
}
