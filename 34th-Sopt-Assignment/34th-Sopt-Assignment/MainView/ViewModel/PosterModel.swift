//
//  PoseterModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

struct PosterModel{
    let posterImage: UIImage
}

extension PosterModel{
    static func dummy() -> [PosterModel] {
        return [
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1),
            PosterModel(posterImage: .bigPoster1)
        ]
    }
}

