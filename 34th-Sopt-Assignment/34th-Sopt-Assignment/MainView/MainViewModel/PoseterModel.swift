//
//  PoseterModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import Foundation
import UIKit

struct PoseterModel{
    let posterImage: UIImage
}

extension PoseterModel{
    static func dummy() -> [PoseterModel] {
        return [
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1),
            PoseterModel(posterImage: .bigPoster1)
        ]
    }
}

