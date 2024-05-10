//
//  MovieAPI.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/9/24.
//

import Foundation
import Moya

// MARK: - Domain
enum MovieOpenDomain {
    case boxoffice
    case movie
}

extension MovieOpenDomain {
    var url: String {
        switch self {
        case .boxoffice:
            return "/boxoffice"
        case .movie:
            return "/movie"
        }
    }
}

protocol MovieOpenAPI: TargetType {
    var domain: MovieOpenDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
}

extension MovieOpenAPI {
    var baseURL: URL {
        return URL(string: PrivacyInfoManager.baseURL)!
    }
    
    var path: String {
        return domain.url + urlPath
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
