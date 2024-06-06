//
//  BoxofficeResponse.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/10/24.
//

import Foundation

// MARK: -일별 박스 오피스 조회 DTO
struct GetDailyBoxOfficeDTO: Codable {
    let boxOfficeResult: DailyBoxOfficeDTO
}

struct DailyBoxOfficeDTO: Codable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]?
}

struct DailyBoxOfficeList: Codable {
    let rnum: String
    let rank: String
    let rankInten: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let salesShare: String
    let salesInten: String
    let salesChange: String
    let salesAcc: String
    let audiCnt: String
    let audiInten: String
    let audiChange: String
    let audiAcc: String
    let scrnCnt: String
    let showCnt: String
}
