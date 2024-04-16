//
//  UIFont.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/15/24.
//

import UIKit

// MARK: - pretendard font
extension UIFont {
    enum PretendardType: String {
        case black = "Black"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case thin = "Thin"
    }
    
    static func pretendard(to type: PretendardType, size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-"+type.rawValue, size: size)!
    }
}

