//
//  Constants.swift
//  MagDataScope
//
//  Created by Ding Xu on 2/2/15.
//  Copyright (c) 2015 Ding Xu. All rights reserved.
//

import Foundation
import UIKit

// the length of scope on x axis
let GRAPH_SIZE = 100

// color micro definition
let redColor:UIColor = colorWithRGB(0xcc3333, alpha: 1.0)
let greenColor:UIColor = colorWithRGB(0x86cc7d, alpha: 1.0)
let blueColor:UIColor =  colorWithRGB(0x336699, alpha: 1.0)
let lineGranphbgColor:UIColor =  colorWithRGB(0xe3f2f6, alpha: 1.0)

// color helper function
func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
    let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
    let blue = CGFloat(rgbValue & 0xFF) / 255
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}