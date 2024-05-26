//
//  UIFont+.swift
//  HARA
//
//  Created by 김담인 on 2023/01/01.
//

import UIKit

public enum UhBeeMiwan: String {
    case bold = "Bold"
    case regular = ""
}

extension UIFont {
    static func printAll() {
        familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            fontNames(forFamilyName: familyName).sorted().forEach { fontName in
                print("\(fontName)")
            }
        }
    }
    
    static func uhbeeMiwan(type: UhBeeMiwan, size: Int) -> UIFont {
        return UIFont(name: "UhBeemiwan\(type.rawValue)", size: CGFloat(size))!
    }
    
    static func uhbeezziba(size: Int) -> UIFont {
        return UIFont(name: "UhBeeZZIBA-Regular", size: CGFloat(size))!
    }
}


