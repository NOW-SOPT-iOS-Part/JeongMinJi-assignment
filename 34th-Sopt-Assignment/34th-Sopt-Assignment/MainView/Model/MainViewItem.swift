//
//  MainViewItem.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

enum MainViewSection: Int {
    case bigMoviePoster = 0
    case recommendInTiving = 1
    case popularLiveChannel = 2
    case popularSeries = 3
    case mysteriousMovie = 4
}

enum MainViewItem {
    case bigMoviePoster(PosterModel)
    case recommendInTiving(MovieModel)
    case popularLiveChannel(DailyBoxOfficeModel)
    case popularSeries(MovieModel)
    case mysteriousMovie(MovieModel)
}
