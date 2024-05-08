//
//  NSObject+.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/9/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
