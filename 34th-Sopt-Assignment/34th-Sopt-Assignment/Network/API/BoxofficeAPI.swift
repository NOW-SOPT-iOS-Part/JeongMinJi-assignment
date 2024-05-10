//
//  Boxoffice.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/10/24.
//

import Foundation
import Moya

enum BoxofficeAPI {
    case getDailyBoxOffice(key: String, targetDt: Int,itemPerPage: Int, multiMovieYn: String, repNationCd: String)
}

extension BoxofficeAPI: MovieOpenAPI {
    var domain: MovieOpenDomain {
        return .boxoffice
    }
    
    var urlPath: String {
        switch self {
        case .getDailyBoxOffice:
            return "/searchDailyBoxOfficeList.json"
        }
    }
    var error: [Int : NetworkError]? {
        .none
    }
    
    var headers: [String : String]? {
        switch self {
        case .getDailyBoxOffice:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDailyBoxOffice:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDailyBoxOffice(
            key: let key,
            targetDt: let targetDt,
            itemPerPage: let itemPerPage,
            multiMovieYn: let multiMovieYn,
            repNationCd: let repNationCd):
            let parameters = [
                "key": key,
                "targetDt": targetDt,
                "itemPerPage": itemPerPage,
                "multiMovieYn": multiMovieYn,
                "repNationCd": repNationCd
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
