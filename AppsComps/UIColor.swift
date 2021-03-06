//
//  UIColor.swift
//  AppsComps
//
//  Created by Meg Crenshaw on 2/15/17.
//  Copyright © 2017 appscomps. All rights reserved.
//  Modified from: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

extension UIColor {
    public convenience init(hexString: String) {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        self.init(white: 0, alpha: 1)
        return
    }
}
