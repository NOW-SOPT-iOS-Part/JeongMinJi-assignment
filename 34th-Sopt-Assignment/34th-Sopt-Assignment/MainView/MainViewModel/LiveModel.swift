//
//  LiveModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import Foundation
import UIKit

struct LiveModel{
    let posterImage: UIImage
    let channelTitle: String
    let subTitle: String
    let rating: String
}

extension LiveModel{
    static func dummy() -> [LiveModel] {
        return [
            LiveModel(posterImage: .livePoster1, channelTitle: "Mnet", subTitle: "보이즈 플래닛 12화", rating: "80.0%"),
            LiveModel(posterImage: .livePoster2, channelTitle: "Mnet", subTitle: "하트시그널 4화", rating: "24.1%"),
            LiveModel(posterImage: .livePoster1, channelTitle: "Mnet", subTitle: "보이즈 플래닛 12화", rating: "80.0%"),
            LiveModel(posterImage: .livePoster2, channelTitle: "Mnet", subTitle: "하트시그널 4화", rating: "24.1%"),
            LiveModel(posterImage: .livePoster1, channelTitle: "Mnet", subTitle: "보이즈 플래닛 12화", rating: "80.0%"),
            LiveModel(posterImage: .livePoster2, channelTitle: "Mnet", subTitle: "하트시그널 4화", rating: "24.1%"),
        ]
    }
}

