//
//  MovieModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

struct MovieModel {
    let posterImage: UIImage
    let title: String
}

extension MovieModel{
    static func dummy() -> [MovieModel] {
        return [
            MovieModel(posterImage: .moviePoster1, title: "시그널"),
            MovieModel(posterImage: .moviePoster2, title: "해리포터와 마법사의 돌"),
            MovieModel(posterImage: .moviePoster3, title: "반지의 제왕"),
            MovieModel(posterImage: .moviePoster4, title: "스즈메의 문단속"),
            MovieModel(posterImage: .moviePoster1, title: "시그널"),
            MovieModel(posterImage: .moviePoster2, title: "해리포터와 마법사의 돌"),
            MovieModel(posterImage: .moviePoster3, title: "반지의 제왕"),
            MovieModel(posterImage: .moviePoster4, title: "스즈메의 문단속")
        ]
    }
}

