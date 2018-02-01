//
//  Utils.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import Cocoa


extension String {
    
    func subtext(from ini: Int, to end: Int) -> String {
        guard ini >= 0 else { return "" }
        guard end >= 0 else { return "" }
        var fin = end
        if ini > self.characters.count { return  "" }
        if end > self.characters.count { fin = self.characters.count }
        let first = self.index(self.startIndex, offsetBy: ini)
        let last  = self.index(self.startIndex, offsetBy: fin)
        let range = first ..< last
        let text = self.substring(with: range)
        
        return text
    }
    
    var money: String {
        if let num = Double(self) {
            return num.money
        } else {
            return (0.0).money
        }
    }
    
    func toMoney(_ decs: Int, comma: Bool) -> String {
        if let num = Double(self) {
            return num.money
        } else {
            //let zero = 0.0
            return (0.0).money
        }
    }
    
    var dateISO: Date {
        var date = Date(timeIntervalSince1970: 0)
        if !self.isEmpty {
            let formatter = ISO8601DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = formatter.date(from: self) ?? date
        }
        return date
    }
    
    func ellipsis(_ n: Int) -> String {
        if self.isEmpty { return "" }
        return self.subtext(from: 0, to: n) + "..."
    }
}

extension Int {
    var str : String {
        return String(describing: self)
    }
}

extension Double {
    var money: String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.alwaysShowsDecimalSeparator = true
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        let text = formatter.string(from: value) ?? "0.00"
        //let text = NumberFormatter.localizedString(from: value, number: .decimal)
        //let text = String(format:"%.2f", self)
        return text
    }
    
    var moneyBlank: String {
        if self == 0.0 { return "" }
        return self.money
    }
}

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let text = formatter.string(from: self)
        return text
    }
    
    static func fromString(_ text: String, format: String) -> Date {
        var date = Date(timeIntervalSince1970: 0)
        if !text.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            date = formatter.date(from: text)!
        }
        return date
    }
}

extension NSColor {
    
    // Use: NSColor(0xffffffff)
    convenience init(hex: Int) {
        var opacity : CGFloat = 1.0
        if hex > 0xffffff {
            opacity = CGFloat((hex >> 24) & 0xff) / 255
        }
        let parts = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255,
            A: opacity
        )
        //print(parts)
        self.init(red: parts.R, green: parts.G, blue: parts.B, alpha: parts.A)
    }
    
    // Use: NSColor(RGB:(128,255,255))
    convenience init(RGB: (Int, Int, Int)) {
        self.init(
            red  : CGFloat(RGB.0)/255,
            green: CGFloat(RGB.1)/255,
            blue : CGFloat(RGB.2)/255,
            alpha: 1.0
        )
    }
    
}


// END
